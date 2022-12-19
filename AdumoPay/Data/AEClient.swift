//
//  AEClient.swift
//  AdumoPaymentTest
//
//  Created by Christopher Smit on 2022/11/23.
//

import Foundation
import Factory
import UIKit
import SwiftUI

public class AEClient {
    public static let shared = AEClient()
    public var delegate: AEClientDelegate?
    private static var authData: AuthData?

    // Dependencies
    @LazyInjected(Container.authRepository) private var authRepo
    @LazyInjected(Container.transRepository) private var transRepo

    // Do not allow initialization of class as its a singleton
    private init() {}

    /// Authenticates the client ID and secret and initialises the AEClient with authenticated data.
    /// This call must be made before attempting to make any subsequent calls to the framework
    ///
    /// - Parameters:
    ///     - clientId: The client ID obtained from Adumo
    ///     - secret: The client secret obtained from Adumo
    public func authenticate(withMerchantId clientId: String, andSecret secret: String) async -> ClientResult<Any?> {
        let result = await authRepo.getToken(for: clientId, using: secret)

        switch result as AuthenticationResult {
        case .success(let data):
            AEClient.authData = data
            return .success(nil)
        case .failure(let error):
            return .failure(error: error)
        }
    }

    /// Destroys an authenticated session
    public func destroy() {
        AEClient.authData = nil
    }

    /// Check if there is a current authenticated session
    public func isAuthenticated() -> Bool {
        return AEClient.authData != nil
    }

    private var webViewContinuation: CheckedContinuation<ClientResult<InitiateResult>, Never>?

    /// Initiates a transaction with a specific transaction input
    ///
    /// - Parameters:
    ///     - transaction: The transaction object to process
    public func initiate(rootViewController: UIViewController, with transaction: Transaction) async -> ClientResult<InitiateResult> {
        transaction.token = AEClient.authData?.accessToken
        let result = await transRepo.initiate(with: transaction, authenticatedWith: AEClient.authData!)

        return await withCheckedContinuation { continuation in
            Task { @MainActor in
                switch result {
                case .success(let data):
                    if data.threeDSecureAuthRequired {
                        webViewContinuation = continuation

                        guard let payload = data.acsPayload, let md = data.acsMD else {
                            webViewContinuation?.resume(returning: .failure(error: InternalError.reason("Required information not obtained from payment gateway.")))
                            return
                        }

                        // 3DSecure is required. Initialise the WebView for BankServ
                        let viewModel = Web3DSecureViewModel(viewController: rootViewController,
                                                             acsBody: AcsBody(TermUrl: transaction.authCallbackUrl,
                                                                              PaReq: payload,
                                                                              MD: md),
                                                             acsUrl: data.acsUrl!,
                                                             cvvRequired: data.cvvRequired)

                        viewModel.delegate = self

                        let webView = Web3DSecureView(
                            viewModel: viewModel,
                            config: Web3DSecureConfig()
                        )
                        let adumo3DSecure = UIHostingController(rootView: webView)
                        let nav = UINavigationController(rootViewController: adumo3DSecure)
                        nav.modalPresentationStyle = .pageSheet

                        // Present View "Modally"
                        rootViewController.present(nav, animated: true, completion: nil)

                    } else {
                        // Can authorise
                        webViewContinuation?.resume(returning: .success(.init(uidTransactionIndex: data.transactionId,
                                                                              PARes: data.acsPayload!,
                                                                              cvvRequired: data.cvvRequired)))
                    }
                case .failure(let error):
                    webViewContinuation?.resume(returning: .failure(error: error))
                }
            }
        }
    }

    /// Authorises funds on the user’s card.
    ///
    /// - Parameters:
    ///     - transactionId: The UUID obtained from the initiate call
    ///     - amount: The amount to be authorised
    ///     - cvv: The card cvv number if required. This is indicated from the initiate response
    /// - Returns: AuthoriseResult
    public func authorise(transactionId: String, amount: Double, cvv: Int?) async -> AuthoriseResult {
        let authDto = AuthoriseDto(transactionId: transactionId, amount: amount, cvv: cvv)
        let result = await transRepo.authorise(with: authDto, authenticateWith: AEClient.authData!)
        return result
    }
}

// MARK: Adumo3DSecureDelegate

extension AEClient: Adumo3DSecureDelegate {

    func didDismissWebView(isCancel: Bool, transactionIndex: String?, pares: String?, cvvRequired: Bool) {
        if !isCancel {
            Task {
                guard let md = transactionIndex else {
                    webViewContinuation?.resume(returning: .failure(error: InternalError.reason("Transaction was not successfully initiated. Missing transaction index.")))
                    return
                }

                guard let payload = pares else {
                    webViewContinuation?.resume(returning: .failure(error: InternalError.reason("Transaction was not successfully initiated. Missing payload.")))
                    return
                }

                let result = await transRepo.authenticate(with: .init(md: md, payload: payload), authenticatedWith: AEClient.authData!)

                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        if Int(data.errorCode) == 200 {
                            self.webViewContinuation?.resume(returning: .success(.init(uidTransactionIndex: md,
                                                                                       PARes: payload,
                                                                                       cvvRequired: cvvRequired)))
                        } else {
                            self.webViewContinuation?.resume(returning: .failure(error: InternalError.reason(data.errorMsg)))
                        }
                    case .failure(let error):
                        self.webViewContinuation?.resume(returning: .failure(error: error))
                    }
                }
            }
        } else {
            AEClient.authData = nil
            webViewContinuation?.resume(returning: .cancelled)
        }
    }
}

public enum ClientResult<T> {
    case success(_ data: T?)
    case failure(error: Error)
    case cancelled
}

public struct InitiateResult {
    public let uidTransactionIndex: String
    public let PARes: String
    public let cvvRequired: Bool
}

enum InternalError: Error {
    case reason(_ errorString: String)

    var description: String {
        switch self {
        case .reason(let errorString):
            return errorString
        }
    }
}

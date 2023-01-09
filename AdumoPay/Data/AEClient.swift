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
    private var webViewContinuation: CheckedContinuation<ClientResult<InitiateResult>, Never>?

    // Dependencies
    @LazyInjected(Container.useCases) private var useCases

    // Do not allow initialization of class as its a singleton
    private init() {}

    /// Authenticates the client ID and secret and initialises the AEClient with authenticated data.
    /// This call must be made before attempting to make any subsequent calls to the framework
    ///
    /// - Parameters:
    ///    - clientId: The client ID obtained from Adumo
    ///    - secret: The client secret obtained from Adumo
    public func authenticate(withMerchantId clientId: String, andSecret secret: String) async -> ClientResult<Any?> {
        let result = await useCases.authenticate.execute(for: clientId, using: secret)

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

    /// Initiates a transaction with a specific transaction input
    ///
    /// - Parameters:
    ///    - transaction: The transaction object to process
    public func initiate(rootViewController: UIViewController, with transaction: Transaction) async -> ClientResult<InitiateResult> {
        transaction.token = AEClient.authData?.accessToken
        let result = await useCases.initiate.execute(with: transaction, authenticatedWith: AEClient.authData!)

        return await withCheckedContinuation { continuation in
            webViewContinuation = continuation

            Task { @MainActor in
                switch result {
                case .success(let data):
                    if data.threeDSecureAuthRequired ?? false {
                        guard let payload = data.acsPayload, let md = data.acsMD else {
                            webViewContinuation?.resume(returning: .failure(error: InternalError("Required information not obtained from payment gateway.")))
                            return
                        }

                        // 3DSecure is required. Initialise the WebView for BankServ
                        let viewModel = Web3DSecureViewModel(viewController: rootViewController,
                                                             acsBody: AcsBody(TermUrl: transaction.authCallbackUrl,
                                                                              PaReq: payload,
                                                                              MD: md),
                                                             acsUrl: data.acsUrl!,
                                                             cvvRequired: data.cvvRequired ?? false)

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
                        guard let transactionId = data.transactionId else {
                            webViewContinuation?.resume(returning: .failure(error: InternalError(data.message ?? "Unknown Error")))
                            return
                        }

                        webViewContinuation?.resume(returning: .success(.init(uidTransactionIndex: transactionId,
                                                                              PARes: data.acsPayload,
                                                                              cvvRequired: data.cvvRequired ?? false)))
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
    ///    - transactionId: The UUID obtained from the initiate call
    ///    - amount: The amount to be authorised
    ///    - cvv: The card cvv number if required. This is indicated from the initiate response
    /// - Returns: AuthoriseResult
    public func authorise(transactionId: String, amount: Double, cvv: Int?) async -> AuthoriseResult {
        let authDto = AuthoriseDto(transactionId: transactionId, amount: amount, cvv: cvv)
        return await useCases.authorise.execute(with: authDto, authenticateWith: AEClient.authData!)
    }

    /// Reverse authorisation of a transaction.
    ///
    ///  - Parameters:
    ///     - transactionId: The UUID of the transaction to be reversed
    ///  - Returns: ReverseResult
    public func reverse(transactionId: String) async -> ReverseResult {
        return await useCases.reverse.execute(transactionId: transactionId, authenticateWith: AEClient.authData!)
    }

    /// Settle the authorised amount to the merchant’s account.
    ///
    /// - Parameters:
    ///    - transactionId: The UUID of the transaction to be settled
    ///    - amount: The amount to be settled
    /// - Returns: SettleResult
    public func settle(transactionId: String, amount: Double) async -> SettleResult {
        let settleDto = SettleDto(transactionId: transactionId, amount: amount)
        return await useCases.settle.execute(with: settleDto, authenticatedWith: AEClient.authData!)
    }

    /// Refund a settled transaction.
    ///
    /// - Parameters:
    ///    - transactionId: The UUID of the transaction to be settled
    ///    - amount: The amount to be settled
    /// - Returns: RefundResult
    public func refund(transactionId: String, amount: Double) async -> RefundResult {
        let refundDto = RefundDto(transactionId: transactionId, amount: amount)
        return await useCases.refund.execute(with: refundDto, authenticatedWith: AEClient.authData!)
    }
}

// MARK: Adumo3DSecureDelegate

extension AEClient: Adumo3DSecureDelegate {

    func didDismissWebView(isCancel: Bool, transactionIndex: String?, pares: String?, cvvRequired: Bool) {
        if !isCancel {
            Task {
                guard let md = transactionIndex else {
                    webViewContinuation?.resume(returning: .failure(error: InternalError("Transaction was not successfully initiated. Missing transaction index.")))
                    return
                }

                guard let payload = pares else {
                    webViewContinuation?.resume(returning: .failure(error: InternalError("Transaction was not successfully initiated. Missing payload.")))
                    return
                }

                let result = await useCases.verify.execute(with: .init(md: md, payload: payload),
                                                           authenticatedWith: AEClient.authData!)

                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        if Int(data.errorCode) == 200 {
                            self.webViewContinuation?.resume(returning: .success(.init(uidTransactionIndex: md,
                                                                                       PARes: payload,
                                                                                       cvvRequired: cvvRequired)))
                        } else {
                            self.webViewContinuation?.resume(returning: .failure(error: InternalError(data.errorMsg)))
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
    public let PARes: String?
    public let cvvRequired: Bool
}

struct InternalError {
    let message: String

    init(_ message: String) {
        self.message = message
    }
}

extension InternalError: LocalizedError {
    var errorDescription: String? { return message }
}


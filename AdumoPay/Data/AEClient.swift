//
//  AEClient.swift
//  AdumoPaymentTest
//
//  Created by Christopher Smit on 2022/11/23.
//

import Foundation
import Factory
import UIKit

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
    public func authenticate(for clientId: String, using secret: String) async -> ClientAuthResult {
        let result = await authRepo.getToken(for: clientId, using: secret)

        switch result as AuthenticationResult {
        case .success(let data):
            AEClient.authData = data
            return .success
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
    ///     - transaction: The transaction object to process
    public func initiate(on viewController: UIViewController, with transaction: Transaction) async {
        let result = await transRepo.initiate(with: transaction, authenticatedWith: AEClient.authData!)

        switch result {
        case .success(let data):
            if data.threeDSecureAuthRequired {
                Task { @MainActor in
                    // 3DSecure is required. Initialise the WebView for BankServ
                    let adumo3DSecure = Adumo3DSecureViewController(
                        acsBody: AcsBody(
                            TermUrl: transaction.authCallbackUrl,
                            PaReq: data.acsPayload,
                            MD: data.acsMD
                        ),
                        acsUrl: data.acsUrl
                    )
                    adumo3DSecure.delegate = self

                    // Present View "Modally"
                    viewController.present(adumo3DSecure, animated: true, completion: nil)
                }
            } else {
                // Can authorise
            }
        case .failure(let error):
            debugPrint(error.localizedDescription)
        }
    }
}

public enum ClientAuthResult {
    case success
    case failure(error: Error)
}

// MARK: Adumo3DSecureDelegate

extension AEClient: Adumo3DSecureDelegate {
    public func didFinishOTPInput(with transactionIndex: String, using pares: String) {
        self.delegate?.on3DSecureFinished(uidTransactionIndex: transactionIndex, PARes: pares)
    }

    public func didCancelOTPInput() {
        AEClient.authData = nil
        self.delegate?.on3DSecureCancelled()
    }
}

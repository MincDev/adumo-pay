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

public class APService: APServiceProtocol {
    public static let shared = APService()
    public var delegate: AEClientDelegate?
    public var environment: Environment = .test
    internal static var authData: AuthData?
    private var webViewContinuation: CheckedContinuation<APResultCancellable<InitiateData>, Never>?

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
    public func authenticate(withMerchantId clientId: String, andSecret secret: String) async -> APResult<Any?> {
        do {
            let data = try await useCases.authenticate.execute(for: clientId, using: secret)
            APService.authData = data
            return .success(nil)
        } catch {
            return .failure(error: error)
        }
    }

    /// Destroys an authenticated session
    public func destroy() {
        APService.authData = nil
    }

    /// Check if there is a current authenticated session
    public func isAuthenticated() -> Bool {
        return APService.authData != nil
    }

    /// Initiates a transaction with a specific transaction input
    ///
    /// - Parameters:
    ///    - transaction: The transaction object to process
    public func initiate(rootViewController: UIViewController, with transaction: Transaction) async -> APResultCancellable<InitiateData> {
        transaction.setToken(APService.authData!.accessToken)
        do {
            let data = try await useCases.initiate.execute(with: transaction)

            return await withCheckedContinuation { continuation in
                webViewContinuation = continuation

                Task {
                    if data.threeDSecureAuthRequired {
                        guard let payload = data.acsPayload, let md = data.acsMD else {
                            webViewContinuation?.resume(returning: .failure(error: InternalError("Required information not obtained from payment gateway.")))
                            return
                        }

                        await MainActor.run {
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
                        }
                    } else {
                        // Can authorise
                        guard let transactionId = data.transactionId else {
                            webViewContinuation?.resume(returning: .failure(error: InternalError(data.message ?? "Unknown Error")))
                            return
                        }

                        webViewContinuation?.resume(returning: .success(.init(uidTransactionIndex: transactionId,
                                                                              cvvRequired: data.cvvRequired ?? false)))
                    }
                }
            }
        } catch {
            return .failure(error: error)
        }
    }

    /// Authorises funds on the user’s card.
    ///
    /// - Parameters:
    ///    - transactionId: The UUID obtained from the initiate call
    ///    - amount: The amount to be authorised
    ///    - cvv: The card cvv number if required. This is indicated from the initiate response
    /// - Returns: AuthoriseResult
    public func authorise(transactionId: String, amount: Double, cvv: Int?) async -> APResult<AuthoriseData> {
        let authDto = AuthoriseDto(transactionId: transactionId, amount: amount, cvv: cvv)
        do {
            let data = try await useCases.authorise.execute(with: authDto)
            return .success(data)
        } catch {
            return .failure(error: error)
        }
    }

    /// Reverse authorisation of a transaction.
    ///
    ///  - Parameters:
    ///     - transactionId: The UUID of the transaction to be reversed
    ///  - Returns: ReverseResult
    public func reverse(transactionId: String) async -> APResult<ReverseData> {
        do {
            let data = try await useCases.reverse.execute(transactionId: transactionId)
            return .success(data)
        } catch {
            return .failure(error: error)
        }
    }

    /// Settle the authorised amount to the merchant’s account.
    ///
    /// - Parameters:
    ///    - transactionId: The UUID of the transaction to be settled
    ///    - amount: The amount to be settled
    /// - Returns: SettleResult
    public func settle(transactionId: String, amount: Double) async -> APResult<SettleData> {
        let settleDto = SettleDto(transactionId: transactionId, amount: amount)
        do {
            let data = try await useCases.settle.execute(with: settleDto)
            return .success(data)
        } catch {
            return .failure(error: error)
        }
    }

    /// Refund a settled transaction.
    ///
    /// - Parameters:
    ///    - transactionId: The UUID of the transaction to be settled
    ///    - amount: The amount to be settled
    /// - Returns: RefundResult
    public func refund(transactionId: String, amount: Double) async -> APResult<RefundData> {
        let refundDto = RefundDto(transactionId: transactionId, amount: amount)
        do {
            let data = try await useCases.refund.execute(with: refundDto)
            return .success(data)
        } catch {
            return .failure(error: error)
        }
    }
}

internal class APServiceInternal: APServiceInternalProtocol {
    internal func getAuthData() -> AuthData? {
        return APService.authData
    }
}

// MARK: Adumo3DSecureDelegate

extension APService: Adumo3DSecureDelegate {

    func didDismissWebView(isCancel: Bool, transactionIndex: String?, pares: String?, cvvRequired: Bool) {
        if !isCancel {
                guard let md = transactionIndex else {
                    webViewContinuation?.resume(returning: .failure(error: InternalError("Transaction was not successfully initiated. Missing transaction index.")))
                    return
                }

                guard let payload = pares else {
                    webViewContinuation?.resume(returning: .failure(error: InternalError("Transaction was not successfully initiated. Missing payload.")))
                    return
                }

                if checkUserCancelled(from: payload) {
                    APService.authData = nil
                    webViewContinuation?.resume(returning: .cancelled)
                    return
                }

                Task {
                    do {
                        let data = try await useCases.verify.execute(with: .init(md: md, payload: payload))

                        await MainActor.run {
                            if Int(data.errorCode) == 200 {
                                self.webViewContinuation?.resume(returning: .success(.init(uidTransactionIndex: md,
                                                                                           cvvRequired: cvvRequired)))
                            } else {
                                self.webViewContinuation?.resume(returning: .failure(error: InternalError(data.errorMsg)))
                            }
                        }
                    } catch {
                        self.webViewContinuation?.resume(returning: .failure(error: error))
                    }
                }
        } else {
            APService.authData = nil
            webViewContinuation?.resume(returning: .cancelled)
        }
    }

    private func checkUserCancelled(from payload: String) -> Bool {
        if let decodedData = Data(base64Encoded: payload) {
            do {
                let bsData = try JSONDecoder().decode(BankServResponseDto.self, from: decodedData)
                if bsData.body.statusCode == BankServStatusCode.authFailed.rawValue {
                    return true
                }
            } catch {
                // fallthrough
                return false
            }
        }
        return false
    }
}

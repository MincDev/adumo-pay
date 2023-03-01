//
//  AEService.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2023/01/10.
//

import Foundation
import UIKit

internal protocol APServiceInternalProtocol {
    func getAuthData() -> AuthData?
}

public protocol APServiceProtocol {
    func authenticate(withMerchantId clientId: String, andSecret secret: String) async -> APResult<Any?>
    func isAuthenticated() -> Bool
    func destroy()
    func initiate(rootViewController: UIViewController, with transaction: Transaction) async -> APResultCancellable<InitiateData>
    func authorise(transactionId: String, amount: Double, cvv: Int?) async -> APResult<AuthoriseData>
    func reverse(transactionId: String) async -> APResult<ReverseData>
    func settle(transactionId: String, amount: Double) async -> APResult<SettleData>
    func refund(transactionId: String, amount: Double) async -> APResult<RefundData>
}

public enum APResult<T> {
    case success(_ data: T?)
    case failure(error: Error)
}

public enum APResultCancellable<T> {
    case success(_ data: T?)
    case failure(error: Error)
    case cancelled
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

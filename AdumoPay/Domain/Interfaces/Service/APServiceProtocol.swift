//
//  AEService.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2023/01/10.
//

import Foundation
import UIKit

public protocol APServiceProtocol {
    func authenticate(withMerchantId clientId: String, andSecret secret: String) async -> ClientResult<Any?>
    func isAuthenticated() -> Bool
    func destroy()
    func initiate(rootViewController: UIViewController, with transaction: Transaction) async -> ClientResult<InitiateResult>
    func authorise(transactionId: String, amount: Double, cvv: Int?) async -> AuthoriseResult
    func reverse(transactionId: String) async -> ReverseResult
    func settle(transactionId: String, amount: Double) async -> SettleResult
    func refund(transactionId: String, amount: Double) async -> RefundResult
}

public enum APError: Error, Equatable {
    case apiError(_ error: NSError?)
    case unknown
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

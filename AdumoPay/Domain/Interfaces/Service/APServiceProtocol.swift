//
//  AEService.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2023/01/10.
//

import Foundation
import UIKit

internal protocol APServiceInternalProtocol {
    func getAuthData() -> AuthResponse?
}

public protocol APServiceProtocol {
    func authenticate(withMerchantId clientId: String, andSecret secret: String) async -> APResult<NoResponse>
    func isAuthenticated() -> Bool
    func destroy()
    func initiate(rootViewController: UIViewController, with transaction: Transaction) async -> APResultCancellable<InitiateResponse>
    func authorise(transactionId: String, amount: Double, cvv: Int?) async -> APResult<AuthoriseResponse>
    func reverse(transactionId: String) async -> APResult<ReverseResponse>
    func settle(transactionId: String, amount: Double) async -> APResult<SettleResponse>
    func refund(transactionId: String, amount: Double) async -> APResult<RefundResponse>
}

public enum NoResponse: Equatable {}

public enum APResult<T: Equatable>: Equatable {
    case success(_ data: T?)
    case failure(error: Error)
    case none

    public static func == (lhs: APResult<T>, rhs: APResult<T>) -> Bool {
        switch (lhs, rhs) {
        case (.success(let data1), .success(let data2)):
            return data1 == data2
        case (.failure(let error1), .failure(let error2)):
            return error1.localizedDescription == error2.localizedDescription
        case (.none, .none):
            return true
        default:
            return false
        }
    }
}

public enum APResultCancellable<T: Equatable>: Equatable {
    case success(_ data: T?)
    case failure(error: Error)
    case cancelled

    public static func == (lhs: APResultCancellable<T>, rhs: APResultCancellable<T>) -> Bool {
        switch (lhs, rhs) {
        case (.success(let leftValue), .success(let rightValue)):
            return leftValue == rightValue
        case (.failure(let leftError), .failure(let rightError)):
            return leftError.localizedDescription == rightError.localizedDescription
        case (.cancelled, .cancelled):
            return true
        default:
            return false
        }
    }
}

struct InternalError: Equatable {
    let message: String

    init(_ message: String) {
        self.message = message
    }
}

extension InternalError: LocalizedError {
    var errorDescription: String? { return message }
}

enum APServiceError: Error {
    case notAuthenticated
}

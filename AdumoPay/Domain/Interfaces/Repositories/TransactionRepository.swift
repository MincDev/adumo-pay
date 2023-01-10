//
//  TransactionRepository.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2022/12/10.
//

import Foundation

protocol TransactionRepository {
    func initiate(with transaction: Transaction, authenticatedWith: AuthData) async -> TransactionInitiateResult
    func authenticate(with body: BankservDto, authenticatedWith authData: AuthData) async -> BankservResult
    func authorise(with transaction: AuthoriseDto, authenticateWith authData: AuthData) async -> AuthoriseResult
    func reverse(transactionId: String, authenticateWith authData: AuthData) async -> ReverseResult
}

enum TransactionInitiateResult: Equatable {
    case success(transaction: TransactionData)
    case failure(error: NSError)
}

internal enum BankservResult {
    case success(data: BankservData)
    case failure(error: Error)
}

public enum AuthoriseResult {
    case success(data: AuthoriseData)
    case failure(error: Error)
}

public struct InitiateResult {
    public let uidTransactionIndex: String
    public let PARes: String?
    public let cvvRequired: Bool
}

public enum ReverseResult {
    case success(data: ReverseData)
    case failure(error: Error)
}

public enum SettleResult {
    case success(data: SettleData)
    case failure(error: Error)
}

public enum RefundResult {
    case success(data: RefundData)
    case failure(error: Error)
}

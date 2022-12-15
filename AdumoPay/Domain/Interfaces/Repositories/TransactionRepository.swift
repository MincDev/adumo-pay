//
//  TransactionRepository.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2022/12/10.
//

import Foundation

protocol TransactionRepository {
    func initiate(with transaction: Transaction, authenticatedWith: AuthData) async -> TransactionResult
    func authenticate(with body: BankservDto, authenticatedWith authData: AuthData) async -> BankservResult
}

public enum TransactionResult {
    case success(transaction: TransactionData)
    case failure(error: Error)
}

internal enum BankservResult {
    case success(data: BankservData)
    case failure(error: Error)
}

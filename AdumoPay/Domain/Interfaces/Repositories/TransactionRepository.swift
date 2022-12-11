//
//  TransactionRepository.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2022/12/10.
//

import Foundation

protocol TransactionRepository {
    func initiate(with transaction: Transaction, authenticatedWith: AuthData) async -> TransactionResult
}

public enum TransactionResult {
    case success(transaction: TransactionData)
    case failure(error: Error)
}

//
//  TransactionRepository.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2022/12/10.
//

import Foundation

protocol TransactionRepository {
    func initiate(with transaction: Transaction, authenticatedWith: AuthData) async throws -> TransactionData
    func verify(with body: BankservDto, authenticatedWith authData: AuthData) async throws -> BankservData
    func authorise(with transaction: AuthoriseDto, authenticateWith authData: AuthData) async throws -> AuthoriseData
    func reverse(transactionId: String, authenticateWith authData: AuthData) async throws -> ReverseData
}

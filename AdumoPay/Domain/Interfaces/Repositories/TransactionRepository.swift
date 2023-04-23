//
//  TransactionRepository.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2022/12/10.
//

import Foundation

protocol TransactionRepository {
    func initiate(with transaction: Transaction) async throws -> TransactionResponse
    func verify(with body: Bankserv) async throws -> BankservResponse
    func authorise(with transaction: Authorise) async throws -> AuthoriseResponse
    func reverse(transactionId: String) async throws -> ReverseResponse
    func settle(transactionId: String, for amount: Double) async throws -> SettleResponse
    func refund(transactionId: String, for amount: Double) async throws -> RefundResponse
}

//
//  TransactionRepository.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2022/12/10.
//

import Foundation

protocol TransactionRepository {
    func initiate(with transaction: Transaction) async throws -> TransactionData
    func verify(with body: BankservDto) async throws -> BankservData
    func authorise(with transaction: AuthoriseDto) async throws -> AuthoriseData
    func reverse(transactionId: String) async throws -> ReverseData
    func settle(transactionId: String, for amount: Double) async throws -> SettleData
    func refund(transactionId: String, for amount: Double) async throws -> RefundData
}

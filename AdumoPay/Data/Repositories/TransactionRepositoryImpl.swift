//
//  TransactionRepositoryImpl.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2022/12/10.
//

import Foundation
import Factory

final class TransactionRepositoryImpl: TransactionRepository {

    @Injected(Container.networkClient) private var network
    @Injected(Container.service) private var service

    func initiate(with transaction: Transaction) async throws -> TransactionData {
        let url = Env.baseURL.appendingPathComponent(ApiEndpoint.initiateTransaction.path).absoluteString
        network.headers = [
            "Content-Type": "application/json",
            "Authorization": try getAuthorisation()
        ]
        network.httpMethod = .post
        network.httpBody = transaction
        return try await network.execute(TransactionData.self, using: url)
    }

    func verify(with body: BankservDto) async throws -> BankservData {
        let url = Env.baseURL.appendingPathComponent(ApiEndpoint.authenticate3ds.path).absoluteString
        network.headers = [
            "Content-Type": "application/json",
            "Authorization": try getAuthorisation()
        ]
        network.httpMethod = .post
        network.httpBody = body
        return try await network.execute(BankservData.self, using: url)
    }

    func authorise(with transaction: AuthoriseDto) async throws -> AuthoriseData {
        let url = Env.baseURL.appendingPathComponent(ApiEndpoint.authorise.path).absoluteString
        network.headers = [
            "Content-Type": "application/json",
            "Authorization": try getAuthorisation()
        ]
        network.httpMethod = .post
        network.httpBody = transaction
        return try await network.execute(AuthoriseData.self, using: url)
    }

    func reverse(transactionId: String) async throws -> ReverseData {
        let url = Env.baseURL.appendingPathComponent(ApiEndpoint.reverse.path).absoluteString
        network.headers = [
            "Content-Type": "application/json",
            "Authorization": try getAuthorisation()
        ]
        network.httpMethod = .post
        network.httpBody = ReverseDto(transactionId: transactionId)
        return try await network.execute(ReverseData.self, using: url)
    }

    func settle(transactionId: String, for amount: Double) async throws -> SettleData {
        let url = Env.baseURL.appendingPathComponent(ApiEndpoint.settle.path).absoluteString
        network.headers = [
            "Content-Type": "application/json",
            "Authorization": try getAuthorisation()
        ]
        network.httpMethod = .post
        network.httpBody = SettleDto(transactionId: transactionId, amount: amount)
        return try await network.execute(SettleData.self, using: url)
    }

    func refund(transactionId: String, for amount: Double) async throws -> RefundData {
        let url = Env.baseURL.appendingPathComponent(ApiEndpoint.refund.path).absoluteString
        network.headers = [
            "Content-Type": "application/json",
            "Authorization": try getAuthorisation()
        ]
        network.httpMethod = .post
        network.httpBody = RefundDto(transactionId: transactionId, amount: amount)
        return try await network.execute(RefundData.self, using: url)
    }

    private func getAuthorisation() throws -> String {
        guard let authData = service.getAuthData() else {
            throw InternalError("Not Authenticated")
        }

        return "\(authData.tokenType.capitalized) \(authData.accessToken)"
    }
}

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

    func initiate(with transaction: Transaction) async throws -> TransactionResponse {
        let url = Env.baseURL.appendingPathComponent(ApiEndpoint.initiateTransaction.path).absoluteString
        network.headers = [
            "Content-Type": "application/json",
            "Authorization": try getAuthorisation()
        ]
        network.httpMethod = .post
        network.httpBody = transaction
        return try await network.execute(TransactionResponse.self, using: url)
    }

    func verify(with body: Bankserv) async throws -> BankservResponse {
        let url = Env.baseURL.appendingPathComponent(ApiEndpoint.authenticate3ds.path).absoluteString
        network.headers = [
            "Content-Type": "application/json",
            "Authorization": try getAuthorisation()
        ]
        network.httpMethod = .post
        network.httpBody = body
        return try await network.execute(BankservResponse.self, using: url)
    }

    func authorise(with transaction: Authorise) async throws -> AuthoriseResponse {
        let url = Env.baseURL.appendingPathComponent(ApiEndpoint.authorise.path).absoluteString
        network.headers = [
            "Content-Type": "application/json",
            "Authorization": try getAuthorisation()
        ]
        network.httpMethod = .post
        network.httpBody = transaction
        return try await network.execute(AuthoriseResponse.self, using: url)
    }

    func reverse(transactionId: String) async throws -> ReverseResponse {
        let url = Env.baseURL.appendingPathComponent(ApiEndpoint.reverse.path).absoluteString
        network.headers = [
            "Content-Type": "application/json",
            "Authorization": try getAuthorisation()
        ]
        network.httpMethod = .post
        network.httpBody = Reverse(transactionId: transactionId)
        return try await network.execute(ReverseResponse.self, using: url)
    }

    func settle(transactionId: String, for amount: Double) async throws -> SettleResponse {
        let url = Env.baseURL.appendingPathComponent(ApiEndpoint.settle.path).absoluteString
        network.headers = [
            "Content-Type": "application/json",
            "Authorization": try getAuthorisation()
        ]
        network.httpMethod = .post
        network.httpBody = Settle(transactionId: transactionId, amount: amount)
        return try await network.execute(SettleResponse.self, using: url)
    }

    func refund(transactionId: String, for amount: Double) async throws -> RefundResponse {
        let url = Env.baseURL.appendingPathComponent(ApiEndpoint.refund.path).absoluteString
        network.headers = [
            "Content-Type": "application/json",
            "Authorization": try getAuthorisation()
        ]
        network.httpMethod = .post
        network.httpBody = Refund(transactionId: transactionId, amount: amount)
        return try await network.execute(RefundResponse.self, using: url)
    }

    private func getAuthorisation() throws -> String {
        guard let authData = service.getAuthData() else {
            throw APServiceError.notAuthenticated
        }

        return "\(authData.tokenType.capitalized) \(authData.accessToken)"
    }
}

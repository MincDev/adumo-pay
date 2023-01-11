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

    func initiate(with transaction: Transaction, authenticatedWith authData: AuthData) async throws -> TransactionData {
        let url = Environment.url.appendingPathComponent(ApiEndpoint.initiateTransaction.path).absoluteString
        network.headers = [
            "Content-Type": "application/json",
            "Authorization": "\(authData.tokenType.capitalized) \(authData.accessToken)"
        ]
        network.httpMethod = .post
        network.httpBody = transaction
        return try await network.execute(TransactionData.self, using: url)
    }

    func verify(with body: BankservDto, authenticatedWith authData: AuthData) async throws -> BankservData {
        let url = Environment.url.appendingPathComponent(ApiEndpoint.authenticate3ds.path).absoluteString
        network.headers = [
            "Content-Type": "application/json",
            "Authorization": "\(authData.tokenType.capitalized) \(authData.accessToken)"
        ]
        network.httpMethod = .post
        network.httpBody = body
        return try await network.execute(BankservData.self, using: url)
    }

    func authorise(with transaction: AuthoriseDto, authenticateWith authData: AuthData) async throws -> AuthoriseData {
        let url = Environment.url.appendingPathComponent(ApiEndpoint.authorise.path).absoluteString
        network.headers = [
            "Content-Type": "application/json",
            "Authorization": "\(authData.tokenType.capitalized) \(authData.accessToken)"
        ]
        network.httpMethod = .post
        network.httpBody = transaction
        network.debugMode = true
        return try await network.execute(AuthoriseData.self, using: url)
    }

    func reverse(transactionId: String, authenticateWith authData: AuthData) async throws -> ReverseData {
        let url = Environment.url.appendingPathComponent(ApiEndpoint.reverse.path).absoluteString
        network.headers = [
            "Content-Type": "application/json",
            "Authorization": "\(authData.tokenType.capitalized) \(authData.accessToken)"
        ]
        network.httpMethod = .post
        network.httpBody = ReverseDto(transactionId: transactionId)
        return try await network.execute(ReverseData.self, using: url)
    }
}

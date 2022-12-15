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

    func initiate(with transaction: Transaction, authenticatedWith authData: AuthData) async -> TransactionResult {
        let url = Environment.url.appendingPathComponent(ApiEndpoint.initiateTransaction.path).absoluteString
        network.headers = [
            "Content-Type": "application/json",
            "Authorization": "\(authData.tokenType.capitalized) \(authData.accessToken)"
        ]
        network.httpMethod = .post
        network.httpBody = transaction

        #if DEBUG
        network.debugMode = true
        #endif

        do {
            let result = try await network.execute(TransactionData.self, using: url)
            return .success(transaction: result)
        } catch {
            return .failure(error: error)
        }
    }

    func authenticate(with body: BankservDto, authenticatedWith authData: AuthData) async -> BankservResult {
        let url = Environment.url.appendingPathComponent(ApiEndpoint.authenticate3ds.path).absoluteString
        network.headers = [
            "Content-Type": "application/json",
            "Authorization": "\(authData.tokenType.capitalized) \(authData.accessToken)"
        ]
        network.httpMethod = .post
        network.httpBody = body

        #if DEBUG
        network.debugMode = true
        #endif

        do {
            let result = try await network.execute(BankservData.self, using: url)
            return .success(data: result)
        } catch {
            return .failure(error: error)
        }
    }
}

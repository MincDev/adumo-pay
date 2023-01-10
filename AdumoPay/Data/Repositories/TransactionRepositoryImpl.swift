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

    func initiate(with transaction: Transaction, authenticatedWith authData: AuthData) async -> TransactionInitiateResult {
        let url = Environment.url.appendingPathComponent(ApiEndpoint.initiateTransaction.path).absoluteString
        network.headers = [
            "Content-Type": "application/json",
            "Authorization": "\(authData.tokenType.capitalized) \(authData.accessToken)"
        ]
        network.httpMethod = .post
        network.httpBody = transaction

        do {
            let result = try await network.execute(TransactionData.self, using: url)
            return .success(transaction: result)
        } catch {
            return .failure(error: error as NSError)
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

        do {
            let result = try await network.execute(BankservData.self, using: url)
            return .success(data: result)
        } catch {
            return .failure(error: error)
        }
    }

    func authorise(with transaction: AuthoriseDto, authenticateWith authData: AuthData) async -> AuthoriseResult {
        let url = Environment.url.appendingPathComponent(ApiEndpoint.authorise.path).absoluteString
        network.headers = [
            "Content-Type": "application/json",
            "Authorization": "\(authData.tokenType.capitalized) \(authData.accessToken)"
        ]
        network.httpMethod = .post
        network.httpBody = transaction
        network.debugMode = true

        do {
            let result = try await network.execute(AuthoriseData.self, using: url)
            return .success(data: result)
        } catch {
            return .failure(error: error)
        }
    }

    func reverse(transactionId: String, authenticateWith authData: AuthData) async -> ReverseResult {
        let url = Environment.url.appendingPathComponent(ApiEndpoint.reverse.path).absoluteString
        network.headers = [
            "Content-Type": "application/json",
            "Authorization": "\(authData.tokenType.capitalized) \(authData.accessToken)"
        ]
        network.httpMethod = .post
        network.httpBody = ReverseDto(transactionId: transactionId)

        do {
            let result = try await network.execute(ReverseData.self, using: url)
            return .success(data: result)
        } catch {
            return .failure(error: error)
        }
    }
}

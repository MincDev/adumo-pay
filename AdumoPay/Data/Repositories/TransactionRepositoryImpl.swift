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

    private let url: String = "https://staging-apiv3.adumoonline.com/products/payments/v1/card/initiate"

    func initiate(with transaction: Transaction, authenticatedWith authData: AuthData) async -> TransactionResult {
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
}

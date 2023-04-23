//
//  InititiateTransactionUseCase.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2023/01/09.
//

import Foundation
import Factory

protocol InitiateTransactionUseCase {
    func execute(with transaction: Transaction) async throws -> TransactionResponse
}

final class InitiateTransactionUseCaseImpl: InitiateTransactionUseCase {
    @LazyInjected(Container.transRepository) private var transRepo

    func execute(with transaction: Transaction) async throws -> TransactionResponse {
        try await transRepo.initiate(with: transaction)
    }
}

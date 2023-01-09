//
//  InititiateTransactionUseCase.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2023/01/09.
//

import Foundation
import Factory

protocol InitiateTransactionUseCase {
    func execute(with transaction: Transaction, authenticatedWith authData: AuthData) async -> TransactionInitiateResult
}

final class InitiateTransactionUseCaseImpl: InitiateTransactionUseCase {
    @LazyInjected(Container.transRepository) private var transRepo

    func execute(with transaction: Transaction, authenticatedWith authData: AuthData) async -> TransactionInitiateResult {
        await transRepo.initiate(with: transaction, authenticatedWith: authData)
    }
}

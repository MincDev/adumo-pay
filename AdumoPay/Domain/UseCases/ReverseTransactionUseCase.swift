//
//  ReverseTransactionUseCase.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2023/01/09.
//

import Foundation
import Factory

protocol ReverseTransactionUseCase {
    func execute(transactionId: String, authenticateWith authData: AuthData) async -> ReverseResult
}

final class ReverseTransactionUseCaseImpl: ReverseTransactionUseCase {
    @LazyInjected(Container.transRepository) private var transRepo

    func execute(transactionId: String, authenticateWith authData: AuthData) async -> ReverseResult {
        await transRepo.reverse(transactionId: transactionId, authenticateWith: authData)
    }
}

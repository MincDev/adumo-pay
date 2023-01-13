//
//  ReverseTransactionUseCase.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2023/01/09.
//

import Foundation
import Factory

protocol ReverseTransactionUseCase {
    func execute(transactionId: String) async throws -> ReverseData
}

final class ReverseTransactionUseCaseImpl: ReverseTransactionUseCase {
    @LazyInjected(Container.transRepository) private var transRepo

    func execute(transactionId: String) async throws -> ReverseData {
        try await transRepo.reverse(transactionId: transactionId)
    }
}

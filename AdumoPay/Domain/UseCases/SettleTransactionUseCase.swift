//
//  SettleTransactionUseCase.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2023/01/09.
//

import Foundation
import Factory

protocol SettleTransactionUseCase {
    func execute(with transaction: SettleDto) async throws -> SettleData
}

final class SettleTransactionUseCaseImpl: SettleTransactionUseCase {
    @LazyInjected(Container.transRepository) private var transRepo

    func execute(with transaction: SettleDto) async throws -> SettleData {
        try await transRepo.settle(transactionId: transaction.transactionId, for: transaction.amount)
    }
}

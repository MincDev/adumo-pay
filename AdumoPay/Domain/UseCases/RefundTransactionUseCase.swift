//
//  RefundTransactionUseCase.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2023/01/09.
//

import Foundation
import Factory

protocol RefundTransactionUseCase {
    func execute(with transaction: RefundDto) async throws -> RefundData
}

final class RefundTransactionUseCaseImpl: RefundTransactionUseCase {
    @LazyInjected(Container.transRepository) private var transRepo

    func execute(with transaction: RefundDto) async throws -> RefundData {
        try await transRepo.refund(transactionId: transaction.transactionId, for: transaction.amount)
    }
}

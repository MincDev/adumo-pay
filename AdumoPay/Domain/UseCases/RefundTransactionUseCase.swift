//
//  RefundTransactionUseCase.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2023/01/09.
//

import Foundation
import Factory

protocol RefundTransactionUseCase {
    func execute(with transaction: Refund) async throws -> RefundResponse
}

final class RefundTransactionUseCaseImpl: RefundTransactionUseCase {
    @LazyInjected(Container.transRepository) private var transRepo

    func execute(with transaction: Refund) async throws -> RefundResponse {
        try await transRepo.refund(transactionId: transaction.transactionId, for: transaction.amount)
    }
}

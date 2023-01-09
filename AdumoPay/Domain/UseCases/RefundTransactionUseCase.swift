//
//  RefundTransactionUseCase.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2023/01/09.
//

import Foundation
import Factory

protocol RefundTransactionUseCase {
    func execute(with transaction: RefundDto, authenticatedWith authData: AuthData) async -> RefundResult
}

final class RefundTransactionUseCaseImpl: RefundTransactionUseCase {
    @LazyInjected(Container.transRepository) private var transRepo

    func execute(with transaction: RefundDto, authenticatedWith authData: AuthData) async -> RefundResult {
        fatalError("Refund Use Case Not Implemented Yet.")
    }
}

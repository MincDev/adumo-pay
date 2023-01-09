//
//  SettleTransactionUseCase.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2023/01/09.
//

import Foundation
import Factory

protocol SettleTransactionUseCase {
    func execute(with transaction: SettleDto, authenticatedWith authData: AuthData) async -> SettleResult
}

final class SettleTransactionUseCaseImpl: SettleTransactionUseCase {
    @LazyInjected(Container.transRepository) private var transRepo

    func execute(with transaction: SettleDto, authenticatedWith authData: AuthData) async -> SettleResult {
        fatalError("Settle Use Case Not Implemented Yet.")
    }
}

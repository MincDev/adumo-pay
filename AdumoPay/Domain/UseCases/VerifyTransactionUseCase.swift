//
//  AuthenticateTransactionUseCase.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2023/01/09.
//

import Foundation
import Factory

protocol VerifyTransactionUseCase {
    func execute(with body: BankservDto) async throws -> BankservData
}

final class VerifyTransactionUseCaseImpl: VerifyTransactionUseCase {
    @LazyInjected(Container.transRepository) private var transRepo

    func execute(with body: BankservDto) async throws -> BankservData {
        try await transRepo.verify(with: body)
    }
}

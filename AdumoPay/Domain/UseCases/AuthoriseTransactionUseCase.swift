//
//  AuthoriseTransactionUseCase.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2023/01/09.
//

import Foundation
import Factory

protocol AuthoriseTransactionUseCase {
    func execute(with transaction: Authorise) async throws -> AuthoriseResponse
}

final class AuthoriseTransactionUseCaseImpl: AuthoriseTransactionUseCase {
    @LazyInjected(Container.transRepository) private var transRepo

    func execute(with transaction: Authorise) async throws -> AuthoriseResponse {
        try await transRepo.authorise(with: transaction)
    }
}

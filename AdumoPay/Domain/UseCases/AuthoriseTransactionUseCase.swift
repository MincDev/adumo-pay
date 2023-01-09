//
//  AuthoriseTransactionUseCase.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2023/01/09.
//

import Foundation
import Factory

protocol AuthoriseTransactionUseCase {
    func execute(with transaction: AuthoriseDto, authenticateWith authData: AuthData) async -> AuthoriseResult
}

final class AuthoriseTransactionUseCaseImpl: AuthoriseTransactionUseCase {
    @LazyInjected(Container.transRepository) private var transRepo

    func execute(with transaction: AuthoriseDto, authenticateWith authData: AuthData) async -> AuthoriseResult {
        await transRepo.authorise(with: transaction, authenticateWith: authData)
    }
}

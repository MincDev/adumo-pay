//
//  AuthenticateTransactionUseCase.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2023/01/09.
//

import Foundation
import Factory

protocol AuthenticateTransactionUseCase {
    func execute(with body: BankservDto, authenticatedWith authData: AuthData) async -> BankservResult
}

final class AuthenticateTransactionUseCaseImpl: AuthenticateTransactionUseCase {
    @LazyInjected(Container.transRepository) private var transRepo

    func execute(with body: BankservDto, authenticatedWith authData: AuthData) async -> BankservResult {
        await transRepo.authenticate(with: body, authenticatedWith: authData)
    }
}

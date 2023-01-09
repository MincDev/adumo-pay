//
//  AuthenticateUseCase.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2023/01/09.
//

import Foundation
import Factory

protocol AuthenticateUseCase {
    func execute(for clientId: String, using secret: String) async -> AuthenticationResult
}

final class AuthenticateUseCaseImpl: AuthenticateUseCase {
    @LazyInjected(Container.authRepository) private var authRepo

    func execute(for clientId: String, using secret: String) async -> AuthenticationResult {
        await authRepo.getToken(for: clientId, using: secret)
    }
}

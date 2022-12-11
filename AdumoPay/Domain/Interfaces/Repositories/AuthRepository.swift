//
//  AuthRepository.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2022/12/07.
//

import Foundation

protocol AuthRepository {
    func getToken(for clientId: String, using secret: String) async -> AuthenticationResult
}

public enum AuthenticationResult {
    case success(data: AuthData)
    case failure(error: Error)
}

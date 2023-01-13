//
//  AuthRepository.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2022/12/07.
//

import Foundation

protocol AuthRepository {
    /// Returns an AuthenticationResult which contains either a success or failure
    ///
    /// - Parameters:
    ///    - clientId: The client id to be used in authentication
    ///    - secret: The client secret to be used in authentication
    /// - Returns: AuthData
    func getToken(for clientId: String, using secret: String) async throws -> AuthData
}

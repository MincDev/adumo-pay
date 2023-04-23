//
//  AuthRepository.swift
//  AdumoPaymentTest
//
//  Created by Christopher Smit on 2022/11/23.
//

import Foundation
import Factory

final class AuthRepositoryImpl: AuthRepository {

    @Injected(Container.networkClient) private var network

    public func getToken(for clientId: String, using secret: String) async throws -> AuthResponse {
        let url = Env.baseURL.appendingPathComponent(ApiEndpoint.authToken.path).absoluteString
        let urlString = "\(url)?grant_type=client_credentials&client_id=\(clientId)&client_secret=\(secret)"
        network.httpMethod = .post
        return try await network.execute(AuthResponse.self, using: urlString)
    }
}

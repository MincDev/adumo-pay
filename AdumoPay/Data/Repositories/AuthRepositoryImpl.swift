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

    public func getToken(for clientId: String, using secret: String) async -> AuthenticationResult {
        let url = Environment.url.appendingPathComponent(ApiEndpoint.authToken.path).absoluteString
        let urlString = "\(url)?grant_type=client_credentials&client_id=\(clientId)&client_secret=\(secret)"
        network.httpMethod = .post
        do {
            let data = try await network.execute(AuthData.self, using: urlString)
            return .success(data: data)
        } catch  {
            return .failure(error: error as NSError)
        }
    }
}

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

    private let url: String = "https://staging-apiv3.adumoonline.com/oauth/token"

    public func getToken(for clientId: String, using secret: String) async -> AuthenticationResult {
        let urlString = "\(url)?grant_type=client_credentials&client_id=\(clientId)&client_secret=\(secret)"
        network.httpMethod = .post
        do {
            let data = try await network.execute(AuthData.self, using: urlString)
            return .success(data: data)
        } catch  {
            return .failure(error: error)
        }
    }
}

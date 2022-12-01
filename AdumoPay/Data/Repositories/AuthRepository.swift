//
//  AuthRepository.swift
//  AdumoPaymentTest
//
//  Created by Christopher Smit on 2022/11/23.
//

import Foundation

struct AuthRepository {
    public init() {}

    private let url: String = "https://staging-apiv3.adumoonline.com/oauth/token"

    public func getToken(for clientId: String, using secret: String, completion: @escaping (AuthData?, Error?) -> Void) {
        let urlString = "\(url)?grant_type=client_credentials&client_id=\(clientId)&client_secret=\(secret)"

        var network = NetworkClient()
        network.httpMethod = .post

        network.execute(AuthData.self, using: urlString) { authData, error in
            if error != nil {
                completion(nil, error)
                return
            }
            completion(authData, nil)
        }
    }
}

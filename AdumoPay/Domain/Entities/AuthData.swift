//
//  AuthToken.swift
//  AdumoPaymentTest
//
//  Created by Christopher Smit on 2022/11/23.
//

import Foundation

public struct AuthData: Entity {
    public let accessToken: String
    public let tokenType: String
    public let expiry: Int
    public let scope: String
    public let jti: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiry = "expires_in"
        case scope = "scope"
        case jti = "jti"
    }
}

//
//  AuthToken.swift
//  AdumoPaymentTest
//
//  Created by Christopher Smit on 2022/11/23.
//

import Foundation

struct AuthData: Entity {
    /// Token required as a bearer token for subsequent calls
    let accessToken: String

    /// Token type - Defaults to bearer
    let tokenType: String

    /// Lifespan of token validity in seconds
    let expiry: Int

    /// Auth scope - Defaults to read
    let scope: String

    /// According to OAuth 2.0 spec
    let jti: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiry = "expires_in"
        case scope = "scope"
        case jti = "jti"
    }
}

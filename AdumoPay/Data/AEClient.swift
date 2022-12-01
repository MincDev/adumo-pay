//
//  AEClient.swift
//  AdumoPaymentTest
//
//  Created by Christopher Smit on 2022/11/23.
//

import Foundation

public class AEClient {
    public static let shared = AEClient()
    public var delegate: AEClientDelegate?

    private static var authData: AuthData?
    
    private var authRepo = AuthRepository()

    // Do not allow initialization of class as its a singleton
    private init() {}

    public func authenticate(for clientId: String, using secret: String) {
        authRepo.getToken(for: clientId, using: secret) { data, error in
            if let authData = data {
                AEClient.authData = authData
                self.delegate?.onAuthenticated()
            } else if let err = error {
                self.delegate?.onAuthenticationFailed(with: err)
            }
        }
    }

    public func isAuthenticated() -> Bool {
        return AEClient.authData != nil
    }

    public func initiateTransaction() {
        
    }
}

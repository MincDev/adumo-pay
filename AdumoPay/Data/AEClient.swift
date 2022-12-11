//
//  AEClient.swift
//  AdumoPaymentTest
//
//  Created by Christopher Smit on 2022/11/23.
//

import Foundation
import Factory

public class AEClient {
    public static let shared = AEClient()
    public var delegate: AEClientDelegate?

    private static var authData: AuthData?
    
    @Injected(Container.authRepository) private var authRepo

    // Do not allow initialization of class as its a singleton
    private init() {}

    /// Authenticates the client ID and secret and initialises the AEClient with authenticated data.
    /// This call must be made before attempting to make any subsequent calls to the framework
    ///
    /// - Parameters:
    ///     - clientId: The client ID obtained from Adumo
    ///     - secret: The client secret obtained from Adumo
    public func authenticate(for clientId: String, using secret: String) async {
        let result = await authRepo.getToken(for: clientId, using: secret)

        switch result as AuthenticationResult {
        case .success(let data):
            AEClient.authData = data
            self.delegate?.onAuthenticated()
        case .failure(let error):
            self.delegate?.onAuthenticationFailed(with: error)
        }
    }

    /// Destroys an authenticated session
    public func destroy() {
        AEClient.authData = nil
    }

    /// Check if there is a current authenticated session
    public func isAuthenticated() -> Bool {
        return AEClient.authData != nil
    }

    public func initiateTransaction() {
        
    }
}

//
//  AuthRepositoryTest.swift
//  AdumoPay_Tests
//
//  Created by Christopher Smit on 2023/01/13.
//

import XCTest
import Mockingbird
import Factory

@testable import AdumoPay

class AuthRepositoryTest: XCTestCase {
    private let mockNetworkClient = mock(NetworkClient.self)
    private var mockAuthRepo: AuthRepositoryImpl!

    override func setUpWithError() throws {
        Container.networkClient.register { self.mockNetworkClient }
        self.mockAuthRepo = AuthRepositoryImpl()
    }

    func testGetTokenInvokesNetworkClient() async throws {
        let mockAuthData = mockAuthData()

        given(await mockNetworkClient.execute(any(AuthData.Type.self), using: any())).willReturn(mockAuthData)

        _ = try await mockAuthRepo.getToken(for: "mock-merchant-id", using: "mock-secret-id")

        verify(await mockNetworkClient.execute(any(AuthData.Type.self), using: any())).wasCalled()
    }


}

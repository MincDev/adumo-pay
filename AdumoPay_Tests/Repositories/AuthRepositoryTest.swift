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
//        let mockEntity = AuthData.self
//        let mockUrl = "mock-url"
//
//        let expectation = expectation(description: "executeNetworkClient")
//        givenSwift(await mockNetworkClient.execute(any(), using: any())).will { _, _ in
//            expectation.fulfill()
//            return mockAuthData()
//        }
//
//        _ = try await mockAuthRepo.getToken(for: "mock-merchant-id", using: "mock-secret-id")
//
//        await waitForExpectations(timeout: 1)
//
//        verify(await mockNetworkClient.execute(mockEntity, using: any())).wasCalled()
    }
}

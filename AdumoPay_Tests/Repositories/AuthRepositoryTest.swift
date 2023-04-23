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
    private let mockApi = mock(NetworkClient.self)
    private var repo: AuthRepositoryImpl!

    override func setUpWithError() throws {
        Container.networkClient.register { self.mockApi }
        self.repo = AuthRepositoryImpl()
    }

    func testGetTokenInvokesNetworkClientWithCorrectData() async throws {
        let url = Env.baseURL.appendingPathComponent(ApiEndpoint.authToken.path).absoluteString
        let mockClientId = "mock-merchant-id"
        let mockClientSecret = "mock-secret-id"
        let expectedUrl = "\(url)?grant_type=client_credentials&client_id=\(mockClientId)&client_secret=\(mockClientSecret)"
        let mockAuthData = mockAuthData()

        given(await mockApi.execute(any(AuthResponse.Type.self), using: any())).willReturn(mockAuthData)

        do {
            let data = try await repo.getToken(for: mockClientId, using: mockClientSecret)
            XCTAssertEqual(mockAuthData, data)
        } catch {
            XCTFail("Expected call to succeed.")
        }

        let captor = ArgumentCaptor<String>()
        verify(await mockApi.execute(any(AuthResponse.Type.self), using: captor.any())).wasCalled()
        XCTAssertEqual(expectedUrl, captor.value)
        verify(mockApi.headers).wasNeverCalled()
        verify(mockApi.httpBody).wasNeverCalled()
        verify(mockApi.httpMethod = .post).wasCalled()
    }

    func testGetTokenThrowsInternalError() async throws {
        let mockClientId = "mock-merchant-id"
        let mockClientSecret = "mock-secret-id"
        let mockError = InternalError("mock-error")

        given(await mockApi.execute(any(AuthResponse.Type.self), using: any())).will { _, _  in
            throw mockError
        }

        do {
            _ = try await repo.getToken(for: mockClientId, using: mockClientSecret)
            XCTFail("Expected call to throw without continuation.")
        } catch {
            XCTAssertEqual(mockError, error as? InternalError)
            XCTAssertEqual("mock-error", mockError.localizedDescription)
        }
    }
}

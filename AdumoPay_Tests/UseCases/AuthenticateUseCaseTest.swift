//
//  AuthenticateUseCaseTest.swift
//  AdumoPay_Tests
//
//  Created by Christopher Smit on 2023/01/10.
//

import XCTest
import Mockingbird
import Factory

@testable import AdumoPay

final class AuthenticateUseCaseTest: XCTestCase {

    private let mockAuthRepo = mock(AuthRepository.self)
    private var useCase: AuthenticateUseCase!

    override func setUpWithError() throws {
        Container.authRepository.register { self.mockAuthRepo }
        useCase = AuthenticateUseCaseImpl()
    }

    func testUseCaseInvokesServiceWithSuccessfulResponse() async {
        let mockResult: AuthData = .init(
            accessToken: "mock-access-token",
            tokenType: "mock-token-type",
            expiry: 0,
            scope: "mock-scope",
            jti: "mock-jti"
        )

        givenSwift(await mockAuthRepo.getToken(for: any(), using: any())).will { _, _ in
            return mockResult
        }

        do {
            let result = try await useCase.execute(for: "mock-merchant-id", using: "mock-secret")
            XCTAssertEqual(result, mockResult)
        } catch {
            XCTFail()
        }

        verify(await mockAuthRepo.getToken(for: any(), using: any())).wasCalled()
    }

    func testUseCaseInvokesServiceWithFailedResponse() async {
        let mockError = MockError()

        givenSwift(await mockAuthRepo.getToken(for: any(), using: any())).will { _, _ in
            throw mockError
        }

        do {
            let _ = try await useCase.execute(for: "mock-merchant-id", using: "mock-secret")
            XCTFail()
        } catch {
            XCTAssertEqual(mockError, error as? MockError)
        }

        verify(await mockAuthRepo.getToken(for: any(), using: any())).wasCalled()
    }
}

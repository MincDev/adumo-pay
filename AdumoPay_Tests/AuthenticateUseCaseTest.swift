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
        let mockResult: AuthenticationResult = .success(data: .init(
            accessToken: "mock-access-token",
            tokenType: "mock-token-type",
            expiry: 0,
            scope: "mock-scope",
            jti: "mock-jti"
        ))

        givenSwift(await mockAuthRepo.getToken(for: any(), using: any())).will { _, _ in
            return mockResult
        }

        let result = await useCase.execute(for: "mock-merchant-id", using: "mock-secret")

        verify(await mockAuthRepo.getToken(for: any(), using: any())).wasCalled()
        XCTAssertEqual(result, mockResult)
    }

    func testUseCaseInvokesServiceWithFailedResponse() async {
        let mockError: AuthenticationResult = .failure(error: MockError() as NSError)

        givenSwift(await mockAuthRepo.getToken(for: any(), using: any())).will { _, _ in
            return mockError
        }

        let result = await useCase.execute(for: "mock-merchant-id", using: "mock-secret")

        verify(await mockAuthRepo.getToken(for: any(), using: any())).wasCalled()
        XCTAssertEqual(result, mockError)
    }
}

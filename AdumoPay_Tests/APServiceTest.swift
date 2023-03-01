//
//  APServiceTest.swift
//  AdumoPay_Tests
//
//  Created by Christopher Smit on 2023/01/13.
//

import XCTest
import Mockingbird
import Factory

@testable import AdumoPay

final class APServiceTest: XCTestCase {

    private let mockNetworkClient = mock(NetworkClient.self)
    private let authUseCase = mock(AuthenticateUseCase.self)
    private let mockAuthRepo = mock(AuthRepository.self)
    private var service: APService!

    override func setUpWithError() throws {
        Container.networkClient.register { self.mockNetworkClient }
        Container.authenticateUseCase.register { self.authUseCase }
        Container.authRepository.register { self.mockAuthRepo }
        service = APService.shared
    }

    func testAuthenticateIsInvokedWithSuccess() async {
        let mockAuthData = mockAuthData()
        let mockMerchantId = "mock-merchant-id"
        let mockSecret = "mock-secret"

        given(await mockNetworkClient.execute(any(AuthData.Type.self), using: "mock-url")).willReturn(mockAuthData)
        given(await mockAuthRepo.getToken(for: any(), using: any())).willReturn(mockAuthData)
        given(await authUseCase.execute(for: any(), using: any())).willReturn(mockAuthData)

        _ = await service.authenticate(withMerchantId: mockMerchantId, andSecret: mockSecret)

        verify(await authUseCase.execute(for: any(), using: any())).wasCalled()
        XCTAssertEqual(APService.authData, mockAuthData)
    }
}

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

    private let authUseCase = mock(AuthenticateUseCase.self)
    private var service: APService!

    override func setUpWithError() throws {
        Container.authenticateUseCase.register { self.authUseCase }
        service = APService.shared
    }

    func testAuthenticateIsSuccessful() async {
//        let mockAuthData = mockAuthData()
//        let mockMerchantId = "mock-merchant-id"
//        let mockSecret = "mock-secret"
//
//        givenSwift(await authUseCase.execute(for: any(), using: any())).will { _, _ in
//            return mockAuthData
//        }
//
//        _ = await service.authenticate(withMerchantId: mockMerchantId, andSecret: mockSecret)
//
//        verify(await authUseCase.execute(for: mockMerchantId, using: mockMerchantId)).wasCalled()
//        XCTAssertEqual(APService.authData, mockAuthData)
    }
}

extension Container {
    // Should only be accessible through Facade
    fileprivate static let authenticateUseCase = Factory<AuthenticateUseCase> { AuthenticateUseCaseImpl() }
    fileprivate static let initiateTransactionUseCase = Factory<InitiateTransactionUseCase> { InitiateTransactionUseCaseImpl() }
    fileprivate static let verifyTransactionUseCase = Factory<VerifyTransactionUseCase> { VerifyTransactionUseCaseImpl() }
    fileprivate static let authoriseTransactionUseCase = Factory<AuthoriseTransactionUseCase> { AuthoriseTransactionUseCaseImpl() }
    fileprivate static let reverseTransactionUseCase = Factory<ReverseTransactionUseCase> { ReverseTransactionUseCaseImpl() }
    fileprivate static let settleTransactionUseCase = Factory<SettleTransactionUseCase> { SettleTransactionUseCaseImpl() }
    fileprivate static let refundTransactionUseCase = Factory<RefundTransactionUseCase> { RefundTransactionUseCaseImpl() }
}

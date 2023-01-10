//
//  InitiateTransactionUseCaseTest.swift
//  AdumoPay_Tests
//
//  Created by Christopher Smit on 2023/01/10.
//

import XCTest
import Mockingbird
import Factory

@testable import AdumoPay

final class InitiateTransactionUseCaseTest: XCTestCase {

    private let mockTransRepo = mock(TransactionRepository.self)
    private var useCase: InitiateTransactionUseCase!

    override func setUpWithError() throws {
        Container.transRepository.register { self.mockTransRepo }
        self.useCase = InitiateTransactionUseCaseImpl()
    }

    func testUseCaseInvokesServiceWithSuccessfulResponse() async {
        let mockResult: TransactionInitiateResult = .success(transaction: mockTransactionData())

        givenSwift(await mockTransRepo.initiate(with: any(), authenticatedWith: any())).will { _, _ in
            return mockResult
        }

        let result = await useCase.execute(with: mockTransaction(), authenticatedWith: mockAuthData())

        verify(await mockTransRepo.initiate(with: any(), authenticatedWith: any())).wasCalled()
        XCTAssertEqual(result, .success(transaction: mockTransactionData()))
    }

    func testUseCaseInvokesServiceWithFailedResponse() async {
        let mockError: TransactionInitiateResult = .failure(error: MockError() as NSError)

        givenSwift(await mockTransRepo.initiate(with: any(), authenticatedWith: any())).will { _, _ in
            return mockError
        }

        let result = await useCase.execute(with: mockTransaction(), authenticatedWith: mockAuthData())

        verify(await mockTransRepo.initiate(with: any(), authenticatedWith: any())).wasCalled()
        XCTAssertEqual(result, mockError)
    }
}

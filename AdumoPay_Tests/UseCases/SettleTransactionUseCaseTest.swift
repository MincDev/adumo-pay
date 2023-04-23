//
//  SettleTransactionUseCaseTest.swift
//  AdumoPay_Tests
//
//  Created by Christopher Smit on 2023/01/13.
//

import XCTest
import Mockingbird
import Factory

@testable import AdumoPay

final class SettleTransactionUseCaseTest: XCTestCase {

    private let mockTransRepo = mock(TransactionRepository.self)
    private var useCase: SettleTransactionUseCase!

    override func setUpWithError() throws {
        Container.transRepository.register { self.mockTransRepo }
        self.useCase = SettleTransactionUseCaseImpl()
    }

    func testUseCaseInvokesRepositoryWithSuccessfulResponse() async {
        let mockResult = mockSettleResponse()

        givenSwift(await mockTransRepo.settle(transactionId: any(), for: any())).will { _, _ in
            return mockResult
        }

        do {
            let result = try await useCase.execute(with: .init(transactionId: "mock-transaction-id", amount: 5))
            XCTAssertEqual(mockResult, result)
        } catch {
            XCTFail()
        }
        verify(await mockTransRepo.settle(transactionId: any(), for: any())).wasCalled()
    }

    func testUseCaseInvokesRepositoryWithFailedResponse() async {
        let mockError = MockError()

        givenSwift(await mockTransRepo.settle(transactionId: any(), for: any())).will { _, _ in
            throw mockError
        }

        do {
            let _ = try await useCase.execute(with: .init(transactionId: "mock-transaction-id", amount: 5))
            XCTFail()
        } catch {
            XCTAssertEqual(mockError, MockError())
        }

        verify(await mockTransRepo.settle(transactionId: any(), for: any())).wasCalled()
    }
}

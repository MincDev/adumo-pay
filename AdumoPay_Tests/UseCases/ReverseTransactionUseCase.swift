//
//  ReverseTransactionUseCase.swift
//  AdumoPay_Tests
//
//  Created by Christopher Smit on 2023/01/13.
//

import XCTest
import Mockingbird
import Factory

@testable import AdumoPay

final class ReverseTransactionUseCaseTest: XCTestCase {

    private let mockTransRepo = mock(TransactionRepository.self)
    private var useCase: ReverseTransactionUseCase!

    override func setUpWithError() throws {
        Container.transRepository.register { self.mockTransRepo }
        self.useCase = ReverseTransactionUseCaseImpl()
    }

    func testUseCaseInvokesRepositoryWithSuccessfulResponse() async {
        let mockResult = mockReverseResponse()

        givenSwift(await mockTransRepo.reverse(transactionId: any())).will { _ in
            return mockResult
        }

        do {
            let result = try await useCase.execute(transactionId: "mock-transaction-id")
            XCTAssertEqual(mockResult, result)
        } catch {
            XCTFail()
        }
        verify(await mockTransRepo.reverse(transactionId: any())).wasCalled()
    }

    func testUseCaseInvokesRepositoryWithFailedResponse() async {
        let mockError = MockError()

        givenSwift(await mockTransRepo.reverse(transactionId: any())).will { _ in
            throw mockError
        }

        do {
            let _ = try await useCase.execute(transactionId: "mock-transaction-id")
            XCTFail()
        } catch {
            XCTAssertEqual(mockError, MockError())
        }

        verify(await mockTransRepo.reverse(transactionId: any())).wasCalled()
    }
}

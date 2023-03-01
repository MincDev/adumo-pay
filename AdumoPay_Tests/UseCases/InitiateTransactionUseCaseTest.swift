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

    func testUseCaseInvokesRepositoryWithSuccessfulResponse() async {
        let mockResult = mockTransactionData()

        givenSwift(await mockTransRepo.initiate(with: any())).will { _ in
            return mockResult
        }

        do {
            let result = try await useCase.execute(with: mockTransaction())
            XCTAssertEqual(mockResult, result)
        } catch {
            XCTFail()
        }
        verify(await mockTransRepo.initiate(with: any())).wasCalled()
    }

    func testUseCaseInvokesRepositoryWithFailedResponse() async {
        let mockError = MockError()

        givenSwift(await mockTransRepo.initiate(with: any())).will { _ in
            throw mockError
        }

        do {
            let _ = try await useCase.execute(with: mockTransaction())
            XCTFail()
        } catch {
            XCTAssertEqual(mockError, MockError())
        }

        verify(await mockTransRepo.initiate(with: any())).wasCalled()
    }
}

//
//  VerifyTransactionUseCase.swift
//  AdumoPay_Tests
//
//  Created by Christopher Smit on 2023/01/13.
//

import XCTest
import Mockingbird
import Factory

@testable import AdumoPay

final class VerifyTransactionUseCaseTest: XCTestCase {

    private let mockTransRepo = mock(TransactionRepository.self)
    private var useCase: VerifyTransactionUseCase!

    override func setUpWithError() throws {
        Container.transRepository.register { self.mockTransRepo }
        self.useCase = VerifyTransactionUseCaseImpl()
    }

    func testUseCaseInvokesRepositoryWithSuccessfulResponse() async {
        let mockResult = mockBankServData()

        givenSwift(await mockTransRepo.verify(with: any())).will { _ in
            return mockResult
        }

        do {
            let result = try await useCase.execute(with: mockBankServDto())
            XCTAssertEqual(mockResult, result)
        } catch {
            XCTFail()
        }
        verify(await mockTransRepo.verify(with: any())).wasCalled()
    }

    func testUseCaseInvokesRepositoryWithFailedResponse() async {
        let mockError = MockError()

        givenSwift(await mockTransRepo.verify(with: any())).will { _ in
            throw mockError
        }

        do {
            let _ = try await useCase.execute(with: mockBankServDto())
            XCTFail()
        } catch {
            XCTAssertEqual(mockError, MockError())
        }

        verify(await mockTransRepo.verify(with: any())).wasCalled()
    }

}

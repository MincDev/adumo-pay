//
//  AuthoriseTransactionUseCaseTest.swift
//  AdumoPay_Tests
//
//  Created by Christopher Smit on 2023/01/13.
//

import XCTest
import Mockingbird
import Factory

@testable import AdumoPay

final class AuthoriseTransactionUseCaseTest: XCTestCase {

    private let mockTransRepo = mock(TransactionRepository.self)
    private var useCase: AuthoriseTransactionUseCase!

    override func setUpWithError() throws {
        Container.transRepository.register { self.mockTransRepo }
        self.useCase = AuthoriseTransactionUseCaseImpl()
    }

    func testUseCaseInvokesRepositoryWithSuccessfulResponse() async {
        let mockResult = mockAuthoriseData()

        givenSwift(await mockTransRepo.authorise(with: any())).will { _ in
            return mockResult
        }

        do {
            let result = try await useCase.execute(with: mockAuthoriseDto())
            XCTAssertEqual(mockResult, result)
        } catch {
            XCTFail()
        }
        verify(await mockTransRepo.authorise(with: any())).wasCalled()
    }

    func testUseCaseInvokesRepositoryWithFailedResponse() async {
        let mockError = MockError()

        givenSwift(await mockTransRepo.authorise(with: any())).will { _ in
            throw mockError
        }

        do {
            let _ = try await useCase.execute(with: mockAuthoriseDto())
            XCTFail()
        } catch {
            XCTAssertEqual(mockError, MockError())
        }

        verify(await mockTransRepo.authorise(with: any())).wasCalled()
    }
}

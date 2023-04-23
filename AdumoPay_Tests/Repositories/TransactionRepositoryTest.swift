//
//  TransactionRepositoryTest.swift
//  AdumoPay_Tests
//
//  Created by Christopher Smit on 2023/02/04.
//

import XCTest
import Mockingbird
import Factory

@testable import AdumoPay

final class TransactionRepositoryTest: XCTestCase {
    private let mockApi = mock(NetworkClient.self)
    private let mockService = mock(APServiceInternalProtocol.self)
    private var repo: TransactionRepositoryImpl!

    override func setUpWithError() throws {
        Container.networkClient.register { self.mockApi }
        Container.service.register { self.mockService }
        self.repo = TransactionRepositoryImpl()
    }

    func testInitiateInvokesNetworkClientWithCorrectData() async throws {
        let expectedUrl = Env.baseURL.appendingPathComponent(ApiEndpoint.initiateTransaction.path).absoluteString
        let mockTransaction = mockTransaction()
        let mockAuthData = mockAuthData()
        let mockTransData = mockTransactionResponse()

        given(mockService.getAuthData()).willReturn(mockAuthData)
        given(await mockApi.execute(any(TransactionResponse.Type.self), using: any())).willReturn(mockTransData)

        do {
            let data = try await repo.initiate(with: mockTransaction)
            XCTAssertEqual(mockTransData, data)
        } catch {
            XCTFail("Expected call to succeed")
        }

        let captor = ArgumentCaptor<String>()
        verify(await mockApi.execute(any(TransactionResponse.Type.self), using: captor.any())).wasCalled()
        XCTAssertEqual(expectedUrl, captor.value)
        verify(mockApi.headers = mockAuthHeader(with: mockAuthData)).wasCalled()
        verify(mockApi.httpBody = mockTransaction).wasCalled()
        verify(mockApi.httpMethod = .post).wasCalled()
    }

    func testInitiateThrowsInternalError() async throws {
        let mockError = InternalError("mock-error")
        let mockTransaction = mockTransaction()

        given(mockService.getAuthData()).willReturn(mockAuthData())
        given(await mockApi.execute(any(TransactionResponse.Type.self), using: any())).will { _, _  in
            throw mockError
        }

        do {
            _ = try await repo.initiate(with: mockTransaction)
            XCTFail("Expected call to throw without continuation.")
        } catch {
            XCTAssertEqual(mockError, error as? InternalError)
            XCTAssertEqual("mock-error", mockError.localizedDescription)
        }
    }

    func testInitiateThrowsNotAuthenticatedError() async throws {
        let mockError: APServiceError = .notAuthenticated
        let mockTransaction = mockTransaction()

        do {
            _ = try await repo.initiate(with: mockTransaction)
            XCTFail("Expected call to throw without continuation.")
        } catch {
            XCTAssertEqual(mockError, APServiceError.notAuthenticated)
        }
    }

    func testVerifyInvokesNetworkClientWithCorrectData() async throws {
        let expectedUrl = Env.baseURL.appendingPathComponent(ApiEndpoint.authenticate3ds.path).absoluteString
        let mockBankserv = mockBankserv()
        let mockAuthData = mockAuthData()
        let mockData = mockBankservResponse()

        given(mockService.getAuthData()).willReturn(mockAuthData)
        given(await mockApi.execute(any(BankservResponse.Type.self), using: any())).willReturn(mockData)

        do {
            let data = try await repo.verify(with: mockBankserv)
            XCTAssertEqual(mockData, data)
        } catch {
            XCTFail("Expected call to succeed")
        }

        let captor = ArgumentCaptor<String>()
        verify(await mockApi.execute(any(BankservResponse.Type.self), using: captor.any())).wasCalled()
        XCTAssertEqual(expectedUrl, captor.value)
        verify(mockApi.headers = mockAuthHeader(with: mockAuthData)).wasCalled()
        verify(mockApi.httpBody = any(Bankserv.self, of: mockBankserv)).wasCalled()
        verify(mockApi.httpMethod = .post).wasCalled()
    }

    func testVerifyThrowsInternalError() async throws {
        let mockError = InternalError("mock-error")
        let mockBankServ = mockBankserv()

        given(mockService.getAuthData()).willReturn(mockAuthData())
        given(await mockApi.execute(any(BankservResponse.Type.self), using: any())).will { _, _  in
            throw mockError
        }

        do {
            _ = try await repo.verify(with: mockBankServ)
            XCTFail("Expected call to throw without continuation.")
        } catch {
            XCTAssertEqual(mockError, error as? InternalError)
            XCTAssertEqual("mock-error", mockError.localizedDescription)
        }
    }

    func testVerifyThrowsNotAuthenticatedError() async throws {
        let mockError: APServiceError = .notAuthenticated
        let mockBankServ = mockBankserv()

        do {
            _ = try await repo.verify(with: mockBankServ)
            XCTFail("Expected call to throw without continuation.")
        } catch {
            XCTAssertEqual(mockError, APServiceError.notAuthenticated)
        }
    }

    func testAuthoriseInvokesNetworkClientWithCorrectData() async throws {
        let expectedUrl = Env.baseURL.appendingPathComponent(ApiEndpoint.authorise.path).absoluteString
        let mockAuthorise = mockAuthorise()
        let mockAuthData = mockAuthData()
        let mockData = mockAuthoriseResponse()

        given(mockService.getAuthData()).willReturn(mockAuthData)
        given(await mockApi.execute(any(AuthoriseResponse.Type.self), using: any())).willReturn(mockData)

        do {
            let data = try await repo.authorise(with: mockAuthorise)
            XCTAssertEqual(mockData, data)
        } catch {
            XCTFail("Expected call to succeed")
        }

        let captor = ArgumentCaptor<String>()
        verify(await mockApi.execute(any(AuthoriseResponse.Type.self), using: captor.any())).wasCalled()
        XCTAssertEqual(expectedUrl, captor.value)
        verify(mockApi.headers = mockAuthHeader(with: mockAuthData)).wasCalled()
        verify(mockApi.httpBody = any(Authorise.self, of: mockAuthorise)).wasCalled()
        verify(mockApi.httpMethod = .post).wasCalled()
    }

    func testAuthoriseThrowsInternalError() async throws {
        let mockError = InternalError("mock-error")
        let mockAuthorise = mockAuthorise()

        given(mockService.getAuthData()).willReturn(mockAuthData())
        given(await mockApi.execute(any(AuthoriseResponse.Type.self), using: any())).will { _, _  in
            throw mockError
        }

        do {
            _ = try await repo.authorise(with: mockAuthorise)
            XCTFail("Expected call to throw without continuation.")
        } catch {
            XCTAssertEqual(mockError, error as? InternalError)
            XCTAssertEqual("mock-error", mockError.localizedDescription)
        }
    }

    func testAuthoriseThrowsNotAuthenticatedError() async throws {
        let mockError: APServiceError = .notAuthenticated
        let mockAuthorise = mockAuthorise()

        do {
            _ = try await repo.authorise(with: mockAuthorise)
            XCTFail("Expected call to throw without continuation.")
        } catch {
            XCTAssertEqual(mockError, APServiceError.notAuthenticated)
        }
    }

    func testReverseInvokesNetworkClientWithCorrectData() async throws {
        let expectedUrl = Env.baseURL.appendingPathComponent(ApiEndpoint.reverse.path).absoluteString
        let mockTransactionId = "mock-transaction-id"
        let mockAuthData = mockAuthData()
        let mockData = mockReverseResponse()

        given(mockService.getAuthData()).willReturn(mockAuthData)
        given(await mockApi.execute(any(ReverseResponse.Type.self), using: any())).willReturn(mockData)

        do {
            let data = try await repo.reverse(transactionId: mockTransactionId)
            XCTAssertEqual(mockData, data)
        } catch {
            XCTFail("Expected call to succeed")
        }

        let captor = ArgumentCaptor<String>()
        verify(await mockApi.execute(any(ReverseResponse.Type.self), using: captor.any())).wasCalled()
        XCTAssertEqual(expectedUrl, captor.value)
        verify(mockApi.headers = mockAuthHeader(with: mockAuthData)).wasCalled()
        verify(mockApi.httpBody = any(Reverse.self, of: Reverse(transactionId: mockTransactionId))).wasCalled()
        verify(mockApi.httpMethod = .post).wasCalled()
    }

    func testReverseThrowsInternalError() async throws {
        let mockError = InternalError("mock-error")
        let mockTransactionId = "mock-transaction-id"

        given(mockService.getAuthData()).willReturn(mockAuthData())
        given(await mockApi.execute(any(ReverseResponse.Type.self), using: any())).will { _, _  in
            throw mockError
        }

        do {
            _ = try await repo.reverse(transactionId: mockTransactionId)
            XCTFail("Expected call to throw without continuation.")
        } catch {
            XCTAssertEqual(mockError, error as? InternalError)
            XCTAssertEqual("mock-error", mockError.localizedDescription)
        }
    }

    func testReverseThrowsNotAuthenticatedError() async throws {
        let mockError: APServiceError = .notAuthenticated
        let mockTransactionId = "mock-transaction-id"

        do {
            _ = try await repo.reverse(transactionId: mockTransactionId)
            XCTFail("Expected call to throw without continuation.")
        } catch {
            XCTAssertEqual(mockError, APServiceError.notAuthenticated)
        }
    }

    func testSettleInvokesNetworkClientWithCorrectData() async throws {
        let expectedUrl = Env.baseURL.appendingPathComponent(ApiEndpoint.settle.path).absoluteString
        let mockTransactionId = "mock-transaction-id"
        let mockAmount = 5.99
        let mockAuthData = mockAuthData()
        let mockData = mockSettleResponse()

        given(mockService.getAuthData()).willReturn(mockAuthData)
        given(await mockApi.execute(any(SettleResponse.Type.self), using: any())).willReturn(mockData)

        do {
            let data = try await repo.settle(transactionId: mockTransactionId, for: mockAmount)
            XCTAssertEqual(mockData, data)
        } catch {
            XCTFail("Expected call to succeed")
        }

        let captor = ArgumentCaptor<String>()
        verify(await mockApi.execute(any(SettleResponse.Type.self), using: captor.any())).wasCalled()
        XCTAssertEqual(expectedUrl, captor.value)
        verify(mockApi.headers = mockAuthHeader(with: mockAuthData)).wasCalled()
        verify(mockApi.httpBody = any(Settle.self, of: Settle(transactionId: mockTransactionId, amount: mockAmount))).wasCalled()
        verify(mockApi.httpMethod = .post).wasCalled()
    }

    func testSettleThrowsInternalError() async throws {
        let mockError = InternalError("mock-error")
        let mockTransactionId = "mock-transaction-id"
        let mockAmount = 5.99

        given(mockService.getAuthData()).willReturn(mockAuthData())
        given(await mockApi.execute(any(SettleResponse.Type.self), using: any())).will { _, _  in
            throw mockError
        }

        do {
            _ = try await repo.settle(transactionId: mockTransactionId, for: mockAmount)
            XCTFail("Expected call to throw without continuation.")
        } catch {
            XCTAssertEqual(mockError, error as? InternalError)
            XCTAssertEqual("mock-error", mockError.localizedDescription)
        }
    }

    func testSettleThrowsNotAuthenticatedError() async throws {
        let mockError: APServiceError = .notAuthenticated
        let mockTransactionId = "mock-transaction-id"
        let mockAmount = 5.99

        do {
            _ = try await repo.settle(transactionId: mockTransactionId, for: mockAmount)
            XCTFail("Expected call to throw without continuation.")
        } catch {
            XCTAssertEqual(mockError, APServiceError.notAuthenticated)
        }
    }

    func testRefundInvokesNetworkClientWithCorrectData() async throws {
        let expectedUrl = Env.baseURL.appendingPathComponent(ApiEndpoint.refund.path).absoluteString
        let mockTransactionId = "mock-transaction-id"
        let mockAmount = 5.99
        let mockAuthData = mockAuthData()
        let mockData = mockRefundResponse()

        given(mockService.getAuthData()).willReturn(mockAuthData)
        given(await mockApi.execute(any(RefundResponse.Type.self), using: any())).willReturn(mockData)

        do {
            let data = try await repo.refund(transactionId: mockTransactionId, for: mockAmount)
            XCTAssertEqual(mockData, data)
        } catch {
            XCTFail("Expected call to succeed")
        }

        let captor = ArgumentCaptor<String>()
        verify(await mockApi.execute(any(RefundResponse.Type.self), using: captor.any())).wasCalled()
        XCTAssertEqual(expectedUrl, captor.value)
        verify(mockApi.headers = mockAuthHeader(with: mockAuthData)).wasCalled()
        verify(mockApi.httpBody = any(Refund.self, of: Refund(transactionId: mockTransactionId, amount: mockAmount))).wasCalled()
        verify(mockApi.httpMethod = .post).wasCalled()
    }

    func testRefundThrowsInternalError() async throws {
        let mockError = InternalError("mock-error")
        let mockTransactionId = "mock-transaction-id"
        let mockAmount = 5.99

        given(mockService.getAuthData()).willReturn(mockAuthData())
        given(await mockApi.execute(any(RefundResponse.Type.self), using: any())).will { _, _  in
            throw mockError
        }

        do {
            _ = try await repo.refund(transactionId: mockTransactionId, for: mockAmount)
            XCTFail("Expected call to throw without continuation.")
        } catch {
            XCTAssertEqual(mockError, error as? InternalError)
            XCTAssertEqual("mock-error", mockError.localizedDescription)
        }
    }

    func testRefundThrowsNotAuthenticatedError() async throws {
        let mockError: APServiceError = .notAuthenticated
        let mockTransactionId = "mock-transaction-id"
        let mockAmount = 5.99

        do {
            _ = try await repo.refund(transactionId: mockTransactionId, for: mockAmount)
            XCTFail("Expected call to throw without continuation.")
        } catch {
            XCTAssertEqual(mockError, APServiceError.notAuthenticated)
        }
    }
}

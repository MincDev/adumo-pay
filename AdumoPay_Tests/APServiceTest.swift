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
    private let authoriseUseCase = mock(AuthoriseTransactionUseCase.self)
    private let initiateUseCase = mock(InitiateTransactionUseCase.self)
    private let reverseUseCase = mock(ReverseTransactionUseCase.self)
    private let settleUseCase = mock(SettleTransactionUseCase.self)
    private let refundUseCase = mock(RefundTransactionUseCase.self)
    private let mockAuthRepo = mock(AuthRepository.self)
    private var service: APService!
    private let stubViewController = StubUIViewController()

    override func setUp() {
        Container.networkClient.register { self.mockNetworkClient }
        Container.authenticateUseCase.register { self.authUseCase }
        Container.initiateTransactionUseCase.register { self.initiateUseCase }
        Container.authoriseTransactionUseCase.register { self.authoriseUseCase }
        Container.reverseTransactionUseCase.register { self.reverseUseCase }
        Container.settleTransactionUseCase.register { self.settleUseCase }
        Container.refundTransactionUseCase.register { self.refundUseCase }
        Container.authRepository.register { self.mockAuthRepo }
        service = APService()
    }

    func testAuthenticateIsInvokedWithSuccess() async {
        let mockAuthData = mockAuthData()
        let mockMerchantId = "mock-merchant-id"
        let mockSecret = "mock-secret"

        given(await authUseCase.execute(for: any(), using: any())).willReturn(mockAuthData)

        let result = await service.authenticate(withMerchantId: mockMerchantId, andSecret: mockSecret)

        verify(await authUseCase.execute(for: mockMerchantId, using: mockSecret)).wasCalled()
        XCTAssertEqual(mockAuthData, APService.authData)
        XCTAssertEqual(APResult.success(.none), result)
    }

    func testAuthenticateIsInvokedWithFailure() async throws {
        let mockError = InternalError("mock-error")
        let mockMerchantId = "mock-merchant-id"
        let mockSecret = "mock-secret"

        given(await authUseCase.execute(for: any(), using: any())).will { _, _ in
            throw mockError
        }

        let result = await service.authenticate(withMerchantId: mockMerchantId, andSecret: mockSecret)

        XCTAssertNil(APService.authData)
        XCTAssertEqual(APResult.failure(error: mockError), result)
    }

    func testDestroyClearsAuthData() {
        let mockAuthData = mockAuthData()
        APService.authData = mockAuthData

        XCTAssertNotNil(APService.authData)

        service.destroy()

        XCTAssertNil(APService.authData)
    }

    func testIsAuthenticatedReturnsCorrectInformation() {
        let mockAuthData = mockAuthData()
        APService.authData = mockAuthData

        var authenticated = service.isAuthenticated()
        XCTAssertTrue(authenticated)

        APService.authData = nil

        authenticated = service.isAuthenticated()
        XCTAssertFalse(authenticated)
    }

    func testInitiateWith3DSecureNotRequiredSucceeds() async {
        let mockTransaction = mockTransaction()
        let mockData = mockTransactionResponse()
        let mockAuthData = mockAuthData()
        APService.authData = mockAuthData

        given(await initiateUseCase.execute(with: any())).willReturn(mockData)

        let result = await service.initiate(rootViewController: stubViewController, with: mockTransaction)

        XCTAssertNotNil(mockTransaction.token)
        XCTAssertEqual(mockTransaction.token, mockAuthData.accessToken)
        XCTAssertEqual(result, .success(.init(uidTransactionIndex: mockData.transactionId!, cvvRequired: mockData.cvvRequired!)))
    }

    func testInitiateWith3DSecureNotRequiredFailsWhenTransactionIdIsNil() async {
        let mockTransaction = mockTransaction()
        let mockData = mockTransactionResponse(noTransactionId: true)
        let mockAuthData = mockAuthData()
        APService.authData = mockAuthData

        given(await initiateUseCase.execute(with: any())).willReturn(mockData)

        let result = await service.initiate(rootViewController: stubViewController, with: mockTransaction)

        XCTAssertNotNil(mockTransaction.token)
        XCTAssertEqual(mockTransaction.token, mockAuthData.accessToken)
        XCTAssertEqual(result, .failure(error: InternalError(mockData.message!)))
    }

    func testInitiateIsInvokedWithFailure() async {
        let mockTransaction = mockTransaction()
        let mockError = InternalError("mock-error")
        let mockAuthData = mockAuthData()
        APService.authData = mockAuthData

        given(await initiateUseCase.execute(with: any())).will { _ in throw mockError }

        let result = await service.initiate(rootViewController: stubViewController, with: mockTransaction)

        XCTAssertEqual(result, .failure(error: mockError))
    }

    func testInitiateFailsWhenNotAuthenticated() async {
        let mockTransaction = mockTransaction()
        let mockError: APServiceError = .notAuthenticated

        let result = await service.initiate(rootViewController: stubViewController, with: mockTransaction)

        XCTAssertEqual(result, .failure(error: mockError))
    }

    func testAuthoriseIsInvokedWithSuccess() async {
        let mockTransId = "mock-transaction-id"
        let mockAmount = 5.99
        let mockCvv = 123
        let mockAuthoriseDto: Authorise = .init(transactionId: mockTransId, amount: mockAmount, cvv: mockCvv)
        let mockData = mockAuthoriseResponse()

        given(await authoriseUseCase.execute(with: any(Authorise.self))).willReturn(mockData)

        let result = await service.authorise(transactionId: mockTransId, amount: mockAmount, cvv: mockCvv)

        verify(await authoriseUseCase.execute(with: mockAuthoriseDto)).wasCalled()
        XCTAssertEqual(APResult.success(mockData), result)
    }

    func testAuthoriseIsInvokedWithFailure() async throws {
        let mockError = InternalError("mock-error")
        let mockTransId = "mock-transaction-id"
        let mockAmount = 5.99
        let mockCvv = 123

        given(await authoriseUseCase.execute(with: any(Authorise.self))).will { _ in
            throw mockError
        }

        let result = await service.authorise(transactionId: mockTransId, amount: mockAmount, cvv: mockCvv)

        XCTAssertEqual(APResult.failure(error: mockError), result)
    }

    func testReverseIsInvokedWithSuccess() async {
        let mockTransId = "mock-transaction-id"
        let mockData = mockReverseResponse()

        given(await reverseUseCase.execute(transactionId: any())).willReturn(mockData)

        let result = await service.reverse(transactionId: mockTransId)

        verify(await reverseUseCase.execute(transactionId: mockTransId)).wasCalled()
        XCTAssertEqual(APResult.success(mockData), result)
    }

    func testReverseIsInvokedWithFailure() async throws {
        let mockError = InternalError("mock-error")
        let mockTransId = "mock-transaction-id"

        given(await reverseUseCase.execute(transactionId: any())).will { _ in
            throw mockError
        }

        let result = await service.reverse(transactionId: mockTransId)

        XCTAssertEqual(APResult.failure(error: mockError), result)
    }

    func testSettleIsInvokedWithSuccess() async {
        let mockTransId = "mock-transaction-id"
        let mockAmount = 5.99
        let mockSettle = Settle(transactionId: mockTransId, amount: mockAmount)
        let mockData = mockSettleResponse()

        given(await settleUseCase.execute(with: any(Settle.self))).willReturn(mockData)

        let result = await service.settle(transactionId: mockTransId, amount: mockAmount)

        verify(await settleUseCase.execute(with: mockSettle)).wasCalled()
        XCTAssertEqual(APResult.success(mockData), result)
    }

    func testSettleIsInvokedWithFailure() async throws {
        let mockError = InternalError("mock-error")
        let mockTransId = "mock-transaction-id"
        let mockAmount = 5.99

        given(await settleUseCase.execute(with: any(Settle.self))).will { _ in
            throw mockError
        }

        let result = await service.settle(transactionId: mockTransId, amount: mockAmount)

        XCTAssertEqual(APResult.failure(error: mockError), result)
    }

    func testRefundIsInvokedWithSuccess() async {
        let mockTransId = "mock-transaction-id"
        let mockAmount = 5.99
        let mockSettle = Refund(transactionId: mockTransId, amount: mockAmount)
        let mockData = mockRefundResponse()

        given(await refundUseCase.execute(with: any(Refund.self))).willReturn(mockData)

        let result = await service.refund(transactionId: mockTransId, amount: mockAmount)

        verify(await refundUseCase.execute(with: mockSettle)).wasCalled()
        XCTAssertEqual(APResult.success(mockData), result)
    }

    func testRefundIsInvokedWithFailure() async throws {
        let mockError = InternalError("mock-error")
        let mockTransId = "mock-transaction-id"
        let mockAmount = 5.99

        given(await refundUseCase.execute(with: any(Refund.self))).will { _ in
            throw mockError
        }

        let result = await service.refund(transactionId: mockTransId, amount: mockAmount)

        XCTAssertEqual(APResult.failure(error: mockError), result)
    }
}

class StubUIViewController: UIViewController {
    var presentExpectation: XCTestExpectation?
    var dismissExpectation: XCTestExpectation?

    var viewControllerToPresent: UIViewController?

    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        self.viewControllerToPresent = viewControllerToPresent
        presentExpectation?.fulfill()
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        dismissExpectation?.fulfill()
    }
}

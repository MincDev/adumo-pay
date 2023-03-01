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

    func testInitiateInvokesNetworkClient() async throws {
        given(mockService.getAuthData()).willReturn(mockAuthData())
        given(await mockApi.execute(any(TransactionData.Type.self), using: any())).willReturn(mockTransactionData())

        _ = try await repo.initiate(with: mockTransaction())

        verify(await mockApi.execute(any(TransactionData.Type.self), using: any())).wasCalled()
    }
}

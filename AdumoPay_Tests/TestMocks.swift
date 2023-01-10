//
//  MockError.swift
//  AdumoPay_Tests
//
//  Created by Christopher Smit on 2023/01/10.
//

import Foundation
@testable import AdumoPay

struct MockError: Error, Equatable {}

func mockAuthData() -> AuthData {
    AuthData(accessToken: "mock-token", tokenType: "mock-token-type", expiry: 0, scope: "mock-scope", jti: "mock-jti")
}

func mockTransaction() -> Transaction {
    Transaction(applicationUid: "mock-app-uid", merchantUid: "mock-merchant-uid", value: 5, merchantReference: "mock-ref", userAgent: "mock-user-agent")
}

func mockTransactionData() -> TransactionData {
    TransactionData(transactionId: "mock-transaction-id", threeDSecureAuthRequired: true, cvvRequired: true, errorCode: "mock-code", message: "mock-message", threeDSecureProvider: "mock-provider", acsUrl: "mock-url", acsPayload: "mock-payload", acsMD: "mock-acs-md", transactionState: "mock-state", profileUid: "mock-uuid", cardCountry: "mock-country", currencyCode: "mock-currency-code", eciFlag: "mock-flag", authorisationCode: "mock-auth-code", processorResponse: "mock-processor-response")
}

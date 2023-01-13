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

func mockBankServDto() -> BankservDto {
    BankservDto(md: "mock-md", payload: "mock-payload")
}

func mockBankServData() -> BankservData {
    BankservData(transactionId: "mock-transaction-id", errorCode: "mock-error-code", message: "mock-message", errorNo: "mock-error-no", errorMsg: "mock-error-msg", eciFlag: "mock-eci-flag", paresStatus: "mock-pares-status", signatureVerification: "mock-signature-verification", xid: "mock-xid", cavv: "mock-cavv")
}

func mockAuthoriseDto() -> AuthoriseDto {
    .init(transactionId: "mock-transaction-id", amount: 5, cvv: nil)
}

func mockAuthoriseData() -> AuthoriseData {
    .init(statusCode: 0, transactionId: "mock-transaction-id", statusMessage: "mock-status-message", eciFlag: "mock-eci-flag", authorisationCode: "mock-authorisation-code", processorResponse: "mock-processor-resp", transactionState: "mock-transaction-state", autoSettle: false, authorisedAmount: 5, cardCountry: "mock-card-country", currencyCode: "mock-currency-code")
}

func mockReverseData() -> ReverseData {
    .init(statusCode: 0, transactionId: "mock-transaction-id", statusMessage: "mock-status-message", eciFlag: "mock-eci-flag", authorisationCode: "mock-authorisation-code", processorResponse: "mock-processor-response", transactionState: "mock-transaction-state", reversedAmount: 5)
}

func mockSettleData() -> SettleData {
    .init(transactionId: "mock-transaction-id", statusCode: 0, statusMessage: "mock-status-message", eciFlag: "mock-eci-flag", autoSettle: false, authorisationCode: "mock-authorisation-code", processorResponse: "mock-processor-response", transactionState: "mock-transaction-state", settledAmount: 5, currencyCode: "mock-currency-code")
}

func mockRefundData() -> RefundData {
    .init(transactionId: "mock-transaction-id", statusCode: 0, statusMessage: "mock-status-message", eciFlag: "mock-eci-flag", authorisationCode: "mock-authorisation-code", processorResponse: "mock-processor-response", transactionState: "mock-transaction-state", refundedAmount: 5)
}

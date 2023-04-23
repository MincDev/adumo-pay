//
//  AuthoriseResponse.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2022/12/19.
//

import Foundation

public struct AuthoriseResponse: Entity {
    /// Status code from user’s bank
    public let statusCode: Int

    /// UID of transaction
    public let transactionId: String?

    /// Status message user’s bank
    public let statusMessage: String

    /// Bankserv ECI flag
    public let eciFlag: String

    /// Bank authorisation code
    public let authorisationCode: String

    /// Bank processor response
    public let processorResponse: String

    /// State of the transaction
    public let transactionState: String?

    /// Indicate whether transaction was auto settled or not on bank side
    public let autoSettle: Bool

    /// Amount sent in to be authorised
    public let authorisedAmount: Double

    /// Country of issue for the card used
    public let cardCountry: String

    /// Code for currency used in transaction
    public let currencyCode: String
}

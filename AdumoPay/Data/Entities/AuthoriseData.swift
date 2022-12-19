//
//  AuthoriseData.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2022/12/19.
//

import Foundation

public struct AuthoriseData: Entity {
    /// Status code from user’s bank
    let statusCode: Int

    /// UID of transaction
    let transactionId: String

    /// Status message user’s bank
    let statusMessage: String

    /// Bankserv ECI flag
    let eciFlag: String

    /// Bank authorisation code
    let authorisationCode: String

    /// Bank processor response
    let processorResponse: String

    /// State of the transaction
    let transactionState: String?

    /// Indicate whether transaction was auto settled or not on bank side
    let autoSettle: Bool

    /// Amount sent in to be authorised
    let authorisedAmount: Double

    /// Country of issue for the card used
    let cardCountry: String

    /// Code for currency used in transaction
    let currencyCode: String
}

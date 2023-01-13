//
//  ReverseData.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2023/01/07.
//

import Foundation

public struct ReverseData: Entity {
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

    /// Amount sent in to be reversed
    public let reversedAmount: Double
}

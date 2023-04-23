//
//  RefundResponse.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2023/01/09.
//

import Foundation

public struct RefundResponse: Entity {
    /// UID of the transaction
    public let transactionId: String?

    /// From user’s bank
    public let statusCode: Int

    /// From user’s bank
    public let statusMessage: String

    /// Bankserv ECI flag
    public let eciFlag: String

    /// Bank authorisation code
    public let authorisationCode: String

    /// Bank processor response
    public let processorResponse: String

    /// State of the transaction
    public let transactionState: String?

    /// Amount sent in to be refunded
    public let refundedAmount: Double
}

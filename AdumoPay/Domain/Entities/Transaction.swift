//
//  Transaction.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2022/12/10.
//

import Foundation

public struct Transaction: Encodable {
    /// Your Application UID provided by Adumo Online
    var applicationUid: String

    /// Your Merchant UID provided by Adumo Online
    var merchantUid: String

    /// Transaction value to two decimal places
    var value: Double

    /// Merchant provided identifying reference for order (eg. order number)
    var merchantReference: String

    /// IP Address of user's device
    var ipAddress: String

    /// User agent for device
    var userAgent: String

    /// Selected budget period
    var budgetPeriod: Int?

    /// Description of transaction
    var description: String?

    /// Unique identifier per transaction
    var originatingTransactionId: String?

    /// User’s card number
    var cardNumber: String?

    /// Card expiry month
    var expiryMonth: Int? {
        didSet {
            if value > 12 || value < 1 {
                fatalError("Invalid expiry month")
            }
        }
    }

    /// Card expiry year
    var expiryYear: Int? {
        didSet {
            let currentYear = Calendar.current.component(.year, from: Date())
            if Int(truncating: value as NSNumber) < currentYear {
                fatalError("Invalid year")
            }
        }
    }

    /// Full names of the card holder
    var cardHolderFullName: String?

    /// Save card details or not
    var saveCardDetails: Bool?

    /// Unique Client Identifier, a way to uniquely identify customers
    var uci: String?

    /// Not currently in use
    var authCallbackUrl: String?

    /// UID of the client’s profile for stored card information
    var profileUid: String?

    /// User’s card token from their profile
    var token: String?

    public init(applicationUid: String, merchantUid: String, value: Double, merchantReference: String, ipAddress: String, userAgent: String, budgetPeriod: Int? = nil, description: String? = nil, originatingTransactionId: String? = nil, cardNumber: String? = nil, expiryMonth: Int? = nil, expiryYear: Int? = nil, cardHolderFullName: String? = nil, saveCardDetails: Bool? = nil, uci: String? = nil, authCallbackUrl: String? = nil, profileUid: String? = nil, token: String? = nil) {
        self.applicationUid = applicationUid
        self.merchantUid = merchantUid
        self.value = value
        self.merchantReference = merchantReference
        self.ipAddress = ipAddress
        self.userAgent = userAgent
        self.budgetPeriod = budgetPeriod
        self.description = description
        self.originatingTransactionId = originatingTransactionId
        self.cardNumber = cardNumber
        self.expiryMonth = expiryMonth
        self.expiryYear = expiryYear
        self.cardHolderFullName = cardHolderFullName
        self.saveCardDetails = saveCardDetails
        self.uci = uci
        self.authCallbackUrl = authCallbackUrl
        self.profileUid = profileUid
        self.token = token
    }
}

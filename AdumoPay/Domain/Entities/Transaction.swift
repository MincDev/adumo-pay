//
//  Transaction.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2022/12/10.
//

import Foundation
import UIKit

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
    var ipAddress: String {
        get {
            if let ipAddress = UIDevice.current.ipAddress() {
                return ipAddress
            } else {
                return "0.0.0.0"
            }
        }
        set {}
    }

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

    public init(applicationUid: String, merchantUid: String, value: Double, merchantReference: String, userAgent: String, budgetPeriod: Int? = nil, description: String? = nil, originatingTransactionId: String? = nil, cardNumber: String? = nil, expiryMonth: Int? = nil, expiryYear: Int? = nil, cardHolderFullName: String? = nil, saveCardDetails: Bool? = nil, uci: String? = nil, authCallbackUrl: String? = nil, profileUid: String? = nil, token: String? = nil) {
        self.applicationUid = applicationUid
        self.merchantUid = merchantUid
        self.value = value
        self.merchantReference = merchantReference
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

    enum CodingKeys: String, CodingKey, CaseIterable {
        case applicationUid
        case merchantUid
        case value
        case merchantReference
        case ipAddress
        case userAgent
        case budgetPeriod
        case description
        case originatingTransactionId
        case cardNumber
        case expiryMonth
        case expiryYear
        case cardHolderFullName
        case saveCardDetails
        case uci
        case authCallbackUrl
        case profileUid
        case token
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(applicationUid, forKey: .applicationUid)
        try container.encode(merchantUid, forKey: .merchantUid)
        try container.encode(value, forKey: .value)
        try container.encode(merchantReference, forKey: .merchantReference)
        try container.encode(ipAddress, forKey: .ipAddress)
        try container.encode(userAgent, forKey: .userAgent)
        try container.encode(budgetPeriod, forKey: .budgetPeriod)
        try container.encode(description, forKey: .description)
        try container.encode(originatingTransactionId, forKey: .originatingTransactionId)
        try container.encode(cardNumber, forKey: .cardNumber)
        try container.encode(expiryMonth, forKey: .expiryMonth)
        try container.encode(expiryYear, forKey: .expiryYear)
        try container.encode(cardHolderFullName, forKey: .cardHolderFullName)
        try container.encode(saveCardDetails, forKey: .saveCardDetails)
        try container.encode(uci, forKey: .uci)
        try container.encode(authCallbackUrl, forKey: .authCallbackUrl)
        try container.encode(profileUid, forKey: .profileUid)
        try container.encode(token, forKey: .token)
    }
}

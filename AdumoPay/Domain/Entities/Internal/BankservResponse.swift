//
//  BankservData.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2022/12/15.
//

import Foundation

internal struct BankservResponse: Entity {
    internal let transactionId: String
    internal let errorCode: String
    internal let message: String
    internal let errorNo: String
    internal let errorMsg: String
    internal let eciFlag: String
    internal let paresStatus: String
    internal let signatureVerification: String
    internal let xid: String?
    internal let cavv: String
}

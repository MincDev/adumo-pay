//
//  RefundDto.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2023/01/09.
//

import Foundation

struct Refund: Encodable, Equatable {
    let transactionId: String
    let amount: Double

    init(transactionId: String, amount: Double) {
        self.transactionId = transactionId
        self.amount = amount
    }
}

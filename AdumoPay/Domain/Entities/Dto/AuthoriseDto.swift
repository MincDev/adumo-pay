//
//  AuthoriseDto.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2022/12/19.
//

import Foundation

struct AuthoriseDto: Encodable {
    let transactionId: String
    let amount: Double
    let cvv: Int?

    init(transactionId: String, amount: Double, cvv: Int?) {
        self.transactionId = transactionId
        self.amount = amount
        self.cvv = cvv
    }
}

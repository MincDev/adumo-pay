//
//  ReverseDto.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2023/01/07.
//

import Foundation

struct ReverseDto: Encodable {
    let transactionId: String

    init(transactionId: String) {
        self.transactionId = transactionId
    }
}

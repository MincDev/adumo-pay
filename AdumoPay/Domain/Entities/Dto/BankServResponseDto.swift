//
//  BankServResponseDto.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2023/01/12.
//

import Foundation

struct BankServResponseDto: Decodable {
    let body: ResponseBody

    struct ResponseBody: Decodable {
        let transactionId: String
        let authorizationAllow: String
        let statusCode: String
        let mdStatus: String
        let statusMessage: String
        let eciFlag: String
        let enrolledStatus: String
        let paresStatus: String
        let paresVerified: String
        let syntaxVerified: String
        let dsId: String?
        let acsId: String
        let acsReference: String
        let cavv: String
        let cavvAlgorithm: String
        let tdsProtocol: String
        let tdsApiVersion: String
        let cardType: String
        let authenticationTime: String
        let authenticationType: String
        let xid: String?
    }
}

enum BankServStatusCode: String {
    case authFailed = "TDS_AUTH_FAILED"
}

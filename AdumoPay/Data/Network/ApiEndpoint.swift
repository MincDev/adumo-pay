//
//  ApiEndpoints.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2022/12/15.
//

import Foundation

enum ApiEndpoint {
    case authToken
    case initiateTransaction
    case authenticate3ds
    case authorise
    case reverse
    case settle
    case refund

    var path: String {
        switch self {
        case .authToken:
            return "/oauth/token"
        case .initiateTransaction:
            return "/products/payments/v1/card/initiate"
        case .authenticate3ds:
            return "/product/authentication/v1/tds/authenticate/"
        case .authorise:
            return "/products/payments/v1/card/authorise"
        case .reverse:
            return "/products/payments/v1/card/reverse"
        case .settle:
            return "/products/payments/v1/card/settle"
        case .refund:
            return "/products/payments/v1/card/refund"
        }
    }
}

// TODO: This struct is for testing only. Must be replaced by something else
struct Environment {
    static var url: URL {
        return URL(string: "https://staging-apiv3.adumoonline.com")!

//        return URL(string: "https://apiv3.adumoonline.com/")!
    }
}

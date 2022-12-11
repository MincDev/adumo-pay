//
//  NSError+CreateError.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2022/12/08.
//

import Foundation

extension NSError {
    public static let unknownErrorCode: Int = Int.min
    public static let unknownDomain: String = "unknown"

    public static func create(_ response: URLResponse?) -> NSError {
        var domain = unknownDomain
        if let url = response?.url {
            domain = url.path
        }
        var code = unknownErrorCode
        if let httpResponse = response as? HTTPURLResponse {
            code = httpResponse.statusCode
        }
        return NSError(domain: domain, code: code)
    }
}

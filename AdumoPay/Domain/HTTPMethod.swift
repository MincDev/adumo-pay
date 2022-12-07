//
//  HTTPMethod.swift
//  AdumoPaymentTest
//
//  Created by Christopher Smit on 2022/11/23.
//

import Foundation

enum HTTPMethod: String, Equatable, Hashable  {
    /// GET Method
    case get = "GET"

    /// POST Method
    case post = "POST"

    /// PUT Method
    case put = "PUT"

    /// PATCH Method
    case patch = "PATCH"

    /// DELETE Method
    case delete = "DELETE"
}

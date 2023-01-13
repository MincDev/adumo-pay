//
//  ErrorResponse.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2022/12/11.
//

import Foundation

public struct ErrorResponse: Error, Entity {
    /// Error code
    let errorCode: String

    /// Error message
    let message: String
}

extension ErrorResponse: LocalizedError {
    public var errorDescription: String? { return message }
}

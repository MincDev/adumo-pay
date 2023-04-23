//
//  InitiateResponse.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2023/01/11.
//

import Foundation

public struct InitiateResponse: Entity {
    /// UID of transaction
    public let uidTransactionIndex: String
    
    /// CVV required for transaction or not
    public let cvvRequired: Bool
}

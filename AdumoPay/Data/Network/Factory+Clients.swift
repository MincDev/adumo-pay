//
//  Factory+Clients.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2022/12/07.
//

import Foundation
import Factory

extension Container {
    static let networkClient = Factory<NetworkClient> { NetworkClientImpl() }
}

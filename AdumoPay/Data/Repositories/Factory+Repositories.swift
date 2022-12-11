//
//  Factory+Repositories.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2022/12/07.
//

import Foundation
import Factory

extension Container {
    static let authRepository = Factory<AuthRepository> { AuthRepositoryImpl() }
    static let transRepository = Factory<TransactionRepository> { TransactionRepositoryImpl() }
}

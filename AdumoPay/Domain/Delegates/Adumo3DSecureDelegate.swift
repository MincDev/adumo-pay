//
//  Adumo3DSecureDelegate.swift
//  AdumoPaymentTest
//
//  Created by Christopher Smit on 2022/11/23.
//

import Foundation

@objc public protocol Adumo3DSecureDelegate {
    func didFinishOTPInput(with transactionIndex: String, using pares: String)

    func didCancelOTPInput()
}

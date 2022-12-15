//
//  Adumo3DSecureDelegate.swift
//  AdumoPaymentTest
//
//  Created by Christopher Smit on 2022/11/23.
//

import Foundation

protocol Adumo3DSecureDelegate {
    func didFinishOTPInput(transactionIndex: String, pares: String)
    func didCancelOTPInput()
}

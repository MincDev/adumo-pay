//
//  Adumo3DSecureDelegate.swift
//  AdumoPaymentTest
//
//  Created by Christopher Smit on 2022/11/23.
//

import Foundation

protocol Adumo3DSecureDelegate {
    func didDismissWebView(isCancel: Bool, transactionIndex: String?, pares: String?, cvvRequired: Bool)
}

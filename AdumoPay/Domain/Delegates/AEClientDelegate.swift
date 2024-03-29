//
//  AEClientDelegate.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2022/12/01.
//

import Foundation

@objc public protocol AEClientDelegate {
    func onTransactionInitiated(uidTransactionIndex: String, PARes: String?)
    func onTransactionInitiateFailed(with error: Error)
    func onTransactionInitiateCancelled()



    @objc optional func on3DSecureFinished(uidTransactionIndex: String, PARes: String)

    @objc optional func on3DSecureFailed(with error: Error)

    @objc optional func on3DSecureCancelled()

    @objc optional func on3DSecureAuthFinished(with response: [String: String])

    @objc optional func on3DSecureAuthFailed(with error: Error)

    @objc optional func onAuthoriseFinished(with response: [String: String])

    @objc optional func onCaptureFinished(with response: [String: String])

    @objc optional func onSaleFinished(with response: [String: String])
}

//
//  Web3DSecureViewModel.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2022/12/15.
//

import Foundation
import WebKit
import SwiftUI

class Web3DSecureViewModel: NSObject, ObservableObject {
    var observation: NSKeyValueObservation? = nil
    var viewController: UIViewController
    var acsBody: AcsBody
    var acsUrl: String
    var delegate: Adumo3DSecureDelegate?
    var webView: WKWebView
    var successful: Bool = false
    var cvvRequired: Bool

    @Published var loadProgress: Double = 0.0

    public init(viewController: UIViewController, acsBody: AcsBody, acsUrl: String, cvvRequired: Bool) {
        self.viewController = viewController
        self.acsBody = acsBody
        self.acsUrl = acsUrl
        self.cvvRequired = cvvRequired
        self.webView = WKWebView()
    }

    deinit {
        observation = nil
    }

    func onLoad() {
        // add observer to update estimated progress value
        observation = webView.observe(\.estimatedProgress, options: [.new]) { _, _ in
            self.loadProgress = (self.webView.estimatedProgress * 100)
        }
    }

    func didTapCancel() {
        viewController.presentedViewController?.dismiss(animated: true)
    }

    func onWebViewFinish(transactionIndex: String, pares: String) {
        successful = true
        viewController.dismiss(animated: true) {
            self.delegate?.didDismissWebView(isCancel: false, transactionIndex: transactionIndex, pares: pares, cvvRequired: self.cvvRequired)
        }
    }

    func onDisappear() {
        if !successful {
            self.delegate?.didDismissWebView(isCancel: true, transactionIndex: nil, pares: nil, cvvRequired: false)
        }
    }
}

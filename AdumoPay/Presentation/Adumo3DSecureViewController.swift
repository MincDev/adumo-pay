//
//  Adumo3DSecureViewController.swift
//  MGFrameworkAppTest
//
//  Created by Christopher Smit on 2022/11/22.
//  Copyright © 2022 Minc Development (Pty) Ltd. All rights reserved.
//

import UIKit
import WebKit

class Adumo3DSecureViewController: UIViewController, WKNavigationDelegate {

    var delegate: Adumo3DSecureDelegate?

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var progressView: UIProgressView!

    private var observation: NSKeyValueObservation? = nil

    override public func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self

        var request = URLRequest(url: URL(string: "https://www.google.co.za/")!)
        request.httpMethod = "POST"
//        request.httpBody = acsBody!.data(using: .utf8)
        webView.load(request)

        // add observer to update estimated progress value
        observation = webView.observe(\.estimatedProgress, options: [.new]) { _, _ in
            self.progressView.progress = Float(self.webView.estimatedProgress)
        }
    }

    deinit {
        observation = nil
    }

    @IBAction public func actionCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true) {
            self.delegate?.didCancelOTPInput!()
        }
    }

    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        switch navigationAction.navigationType {
            case .linkActivated:
            if let url = navigationAction.request.url, url.absoluteString == "https://www.google.co.za/" {
                if let aBody = navigationAction.request.httpBody {
                    let bodyArr = String(data: aBody, encoding: .utf8)?.removingPercentEncoding?.components(separatedBy: "&")
                    var TransIndex: String = ""
                    var Payload: String = ""
                    for item in bodyArr! {
                        if (item.contains("MD=")) {
                            TransIndex = item.replacingOccurrences(of: "MD=", with: "")
                        } else {
                            Payload = item.replacingOccurrences(of: "PaRes=", with: "")
                        }
                    }

                    self.dismiss(animated: true) {
                        self.delegate?.didFinishOTPInput!(with: TransIndex, using: Payload)
                    }
                }
            return
            }
            default:
                break
        }

        if let url = navigationAction.request.url {
            print(url.absoluteString)
        }
        decisionHandler(.allow)
    }

}

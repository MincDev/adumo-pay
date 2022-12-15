//
//  Adumo3DSecureViewController.swift
//  MGFrameworkAppTest
//
//  Created by Christopher Smit on 2022/11/22.
//  Copyright © 2022 Minc Development (Pty) Ltd. All rights reserved.
//

import UIKit
import WebKit

struct AcsBody {
    let TermUrl: String
    let PaReq: String
    let MD: String

    enum Keys: String {
        case TermUrl
        case PaReq
        case MD
    }
}

class Adumo3DSecureViewController: UIViewController, WKNavigationDelegate {

    var acsBody: AcsBody
    var acsUrl: String
    var delegate: Adumo3DSecureDelegate?

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var progressView: UIProgressView!

    private var observation: NSKeyValueObservation? = nil

    public init(acsBody: AcsBody, acsUrl: String) {
        self.acsBody = acsBody
        self.acsUrl = acsUrl
        super.init(nibName: "Adumo3DSecureView", bundle: Bundle(identifier: "co.za.mincdevelopment.AdumoPay")!)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self

        let boundary = UUID().uuidString
        var request = URLRequest(url: URL(string: acsUrl)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = httpBody(from: acsBody, boundary: boundary) as Data

        request.addValue("\(request.httpBody?.count ?? 0)", forHTTPHeaderField: "Content-Length")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        debugPrint("Request Body: ******************* \n\n \(NSString(data: request.httpBody!, encoding: String.Encoding.utf8.rawValue) ?? "No Request Body")")

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
            self.delegate?.didCancelOTPInput()
        }
    }

    private func httpBody(from acsBody: AcsBody, boundary: String) -> NSData {
        let body = NSMutableData()

        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(AcsBody.Keys.TermUrl.rawValue)\"\r\n\r\n")
        body.appendString(string: "\(acsBody.TermUrl)\r\n")

        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(AcsBody.Keys.PaReq.rawValue)\"\r\n\r\n")
        body.appendString(string: "\(acsBody.PaReq)\r\n")

        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(AcsBody.Keys.MD.rawValue)\"\r\n\r\n")
        body.appendString(string: "\(acsBody.MD)\r\n")

        body.appendString(string: "--\(boundary)--\r\n")
        return body
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        let jscript = """
            var meta = document.createElement('meta');
            meta.setAttribute('name', 'viewport');
            meta.setAttribute('content', 'width=device-width, height=device-height, initial-scale=1, minimum-scale=1, maximum-scale=1');
            document.getElementsByTagName('head')[0].appendChild(meta);
        """
        webView.evaluateJavaScript(jscript)
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        if let url = navigationAction.request.url, url.absoluteString == acsBody.TermUrl {
            if let aBody = navigationAction.request.httpBody {
                let bodyArr = String(data: aBody, encoding: .utf8)?.removingPercentEncoding?.components(separatedBy: "&")
                var transIndex: String = ""
                var payload: String = ""
                for item in bodyArr! {
                    if (item.contains("MD=")) {
                        transIndex = item.replacingOccurrences(of: "MD=", with: "")
                    } else {
                        payload = item.replacingOccurrences(of: "PaRes=", with: "")
                    }
                }

                self.dismiss(animated: true) {
                    self.delegate?.didFinishOTPInput(transactionIndex: transIndex, pares: payload)
                }
            }
        }
        decisionHandler(.allow)
    }

}

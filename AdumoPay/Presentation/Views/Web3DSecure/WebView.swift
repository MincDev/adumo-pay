//
//  WebViewRepresentable.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2022/12/15.
//

import Foundation
import WebKit
import SwiftUI

struct WebView : UIViewRepresentable {
    let viewModel: Web3DSecureViewModel
    var webView: WKWebView

    init(viewModel: Web3DSecureViewModel, webView: WKWebView) {
        self.viewModel = viewModel
        self.webView = webView
    }

    class Coordinator: NSObject, WKUIDelegate, WKNavigationDelegate {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }

        // Delegate methods go here

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

            if let url = navigationAction.request.url, url.absoluteString == parent.viewModel.acsBody.TermUrl {
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

                    parent.viewModel.onWebViewFinish(transactionIndex: transIndex, pares: payload)
                }
            }
            decisionHandler(.allow)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView  {
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.uiDelegate = context.coordinator
        uiView.navigationDelegate = context.coordinator

        let boundary = UUID().uuidString
        var request = URLRequest(url: URL(string: viewModel.acsUrl)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = httpBody(from: viewModel.acsBody, boundary: boundary) as Data
        request.addValue("\(request.httpBody?.count ?? 0)", forHTTPHeaderField: "Content-Length")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        webView.load(request)
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
}

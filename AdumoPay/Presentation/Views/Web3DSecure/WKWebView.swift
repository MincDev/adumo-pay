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
    let request: URLRequest
    var webview: WKWebView

    init(req: URLRequest) {
        self.webview = WKWebView()
        self.request = req
    }

    class Coordinator: NSObject, WKUIDelegate {
        var parent: WKWebView

        init(_ parent: WKWebView) {
            self.parent = parent
        }

        // Delegate methods go here

        func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
            // alert functionality goes here
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView  {
        return webview
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.uiDelegate = context.coordinator
        uiView.load(request)
    }
}

//
//  Web3DSecureView.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2022/12/15.
//

import SwiftUI

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

struct Web3DSecureView: View {
    @ObservedObject var viewModel: Web3DSecureViewModel
    let config: Web3DSecureConfig

    var body: some View {
        VStack {
            ProgressView(value: viewModel.loadProgress, total: 100)
            WebView(viewModel: viewModel, webView: viewModel.webView)
        }
        .navigationTitle(config.strings.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button(action: viewModel.didTapCancel) {
                Image(systemName: "xmark")
            }
            .accessibilityLabel("Cancel")
        }
        .onAppear {
            viewModel.onLoad()
        }
        .onDisappear {
            viewModel.onDisappear()
        }
    }
}

struct Web3DSecureView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Web3DSecureView(
                viewModel: Web3DSecureViewModel(
                    viewController: UIViewController(),
                    acsBody: AcsBody(
                        TermUrl: "",
                        PaReq: "",
                        MD: ""
                    ),
                    acsUrl: "https://www.example.com/",
                    cvvRequired: false
                ),
                config: Web3DSecureConfig())
        }
    }
}

//
//  Web3DSecureConfig.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2022/12/15.
//

import Foundation
import SwiftUI

public struct Web3DSecureConfig {
    public let strings: Strings
    public let design: Design

    public init(strings: Strings = Strings(), design: Design = Design()) {
        self.strings = strings
        self.design = design
    }

    public struct Strings {
        let title: String

        public init(
            title: String = "3D Secure Authentication"
        ) {
            self.title = title
        }
    }

    public struct Design {
        let navBarColor: Color
        let navBarTitleColor: Color

        public init(
            navBarColor: Color = .white,
            navBarTitleColor: Color = .black
        ) {
            self.navBarColor = navBarColor
            self.navBarTitleColor = navBarTitleColor
        }
    }
}

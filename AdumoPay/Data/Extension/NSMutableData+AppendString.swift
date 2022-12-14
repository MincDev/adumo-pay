//
//  NSMutableData+AppendString.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2022/12/14.
//

import Foundation

extension NSMutableData {
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

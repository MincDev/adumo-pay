//
//  NetworkClient.swift
//  AdumoPay
//
//  Created by Christopher Smit on 2022/12/10.
//

import Foundation

protocol NetworkClient {
    typealias HTTPBody = (any Encodable)

    /// Headers to be used for the request
    var headers: HTTPHeaders? { get set }

    /// Whether to pring out debug log information
    var debugMode: Bool { get set }

    /// The method to use for the data task
    var httpMethod: HTTPMethod { get set }

    /// The body to be posted
    var httpBody: HTTPBody? { get set }

    /// Executes a network data task and returns an expected Entity Object
    ///
    /// - Parameters:
    ///     - type: The Entity class that is expected to be returned
    ///     - urlString: The url string to be used for the data task
    func execute<T: Entity>(_ type: T.Type, using urlString: String) async throws -> T
}

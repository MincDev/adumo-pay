//
//  NetworkClient.swift
//  AdumoPaymentTest
//
//  Created by Christopher Smit on 2022/11/24.
//

import Foundation

protocol NetworkClient {
    var headers: HTTPHeaders? { get set }
    var debugMode: Bool { get set }
    var httpMethod: HTTPMethod { get set }

    func execute<T: Entity>(_ type: T.Type, using urlString: String) async throws -> T
}

struct NetworkClientImpl: NetworkClient {

    /// Headers to be used for the request
    var headers: HTTPHeaders?

    /// Whether to pring out debug log information
    var debugMode: Bool = false

    /// The method to use for the data task
    var httpMethod: HTTPMethod = .get

    /// Executes a network data task and returns an expected Entity Object
    ///
    /// - Parameters:
    ///     - type: The Entity class that is expected to be returned
    ///     - urlString: The url string to be used for the data task
    func execute<T: Entity>(_ type: T.Type, using urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue

        if let safeHeaders = headers {
            safeHeaders.forEach { header in
                request.setValue(header.value, forHTTPHeaderField: header.name)
            }
        }

        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: request) { data, response, err in
                if err != nil {
                    guard let error = err else {
                        fatalError("Expected non-nil result 'error1' in the non-error case")
                    }
                    continuation.resume(throwing: error)
                    return
                }

                if debugMode {
                    print("Response Body: ******************* \n\n \(NSString(data: data!, encoding: String.Encoding.utf8.rawValue) ?? "No Response Body")")
                }

                if let safeData = data {
                    do {
                        let objData = try JSONDecoder().decode(type.self, from: safeData)
                        continuation.resume(returning: objData)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }.resume()
        }
    }
}

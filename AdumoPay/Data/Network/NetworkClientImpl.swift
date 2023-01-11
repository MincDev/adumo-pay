//
//  NetworkClient.swift
//  AdumoPaymentTest
//
//  Created by Christopher Smit on 2022/11/24.
//

import Foundation

struct NetworkClientImpl: NetworkClient {
    var headers: HTTPHeaders?
    var debugMode: Bool = false
    var httpMethod: HTTPMethod = .get
    var httpBody: (any Encodable)?

    func execute<T: Entity>(_ type: T.Type, using urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue

        if let safeHeaders = headers {
            safeHeaders.forEach { header in
                request.setValue(header.value, forHTTPHeaderField: header.name)
            }
        }

        if let body = httpBody {
            request.httpBody = try JSONEncoder().encode(body)
        }

        if debugMode {
            debugPrint("Request Body: ******************* \n\n \(NSString(data: request.httpBody!, encoding: String.Encoding.utf8.rawValue) ?? "No Request Body")")
        }

        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: request) { data, response, err in
                if err != nil {
                    continuation.resume(throwing: NSError.create(response))
                    return
                }

                if debugMode {
                    debugPrint("Response Body: ******************* \n\n \(NSString(data: data!, encoding: String.Encoding.utf8.rawValue) ?? "No Response Body")")
                }

                switch (response as? HTTPURLResponse)?.statusCode {
                case 200:
                    if let safeData = data {
                        do {
                            let objData = try JSONDecoder().decode(type.self, from: safeData)
                            continuation.resume(returning: objData)
                        } catch {
                            continuation.resume(throwing: APError.decodeError(error as NSError))
                        }
                    }
                default:
                    continuation.resume(throwing: APError.apiError(.create(response)))
                }
            }.resume()
        }
    }
}

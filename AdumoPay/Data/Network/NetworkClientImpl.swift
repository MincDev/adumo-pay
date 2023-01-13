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
        let requestBody = NSString(data: request.httpBody!, encoding: String.Encoding.utf8.rawValue) ?? "No Request Body"

        if let safeHeaders = headers {
            safeHeaders.forEach { header in
                request.setValue(header.value, forHTTPHeaderField: header.name)
            }
        }

        if let body = httpBody {
            request.httpBody = try JSONEncoder().encode(body)
        }

        if debugMode {
            debugPrint("Request Body: ******************* \n\n \(requestBody)")
        }

        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: request) { data, response, err in
                if err != nil {
                    continuation.resume(throwing: InternalError(err?.localizedDescription ?? "Unknown Network Error") as NSError)
                    return
                }

                let httpStatusCode = (response as? HTTPURLResponse)?.statusCode ?? 500
                let responseBody = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) ?? "Internal Server Error"

                if debugMode {
                    debugPrint("Response Body: ******************* \n\n\(responseBody)")
                }

                switch httpStatusCode {
                case 200:
                    if let safeData = data {
                        do {
                            let objData = try JSONDecoder().decode(type.self, from: safeData)
                            continuation.resume(returning: objData)
                        } catch {
                            continuation.resume(throwing: InternalError(error.localizedDescription) as NSError)
                        }
                    }
                default:
                    if let safeData = data {
                        do {
                            let objData = try JSONDecoder().decode(ErrorResponse.self, from: safeData)
                            continuation.resume(throwing: objData)
                        } catch {
                            continuation.resume(throwing: InternalError(error.localizedDescription) as NSError)
                        }
                    } else {
                        continuation.resume(throwing: InternalError("Call threw a HTTP \(httpStatusCode) with response body: \(responseBody)") as NSError)
                    }
                }
            }.resume()
        }
    }
}

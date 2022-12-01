//
//  NetworkClient.swift
//  AdumoPaymentTest
//
//  Created by Christopher Smit on 2022/11/24.
//

import Foundation

struct NetworkClient {

    /// Headers to be used for the request
    var headers: String?

    /// Whether to pring out debug log information
    var debugMode: Bool = false

    /// The method to use for the data task
    var httpMethod: HTTPMethod = .get

    /// Executes a network data task and returns an expected CodableEntity Object
    ///
    /// - Parameters:
    ///     - type: The CodableEntity class that is expected to be returned
    ///     - urlString: The url string to be used for the data task
    ///     - completion: Completion handler that returns the expected CodableObject or an Error
    ///
    func execute<T: CodableEntity>(_ type: T.Type, using urlString: String, completion: @escaping (_ object: T?, _ error: Error?) -> Void) {
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = httpMethod.rawValue
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    completion(nil, error)
                    return
                }

                if debugMode {
                    print("Response Body: ******************* \n\n \(NSString(data: data!, encoding: String.Encoding.utf8.rawValue) ?? "No Response Body")")
                }

                if let safeData = data {
                    do {
                        let objData = try JSONDecoder().decode(type.self, from: safeData)
                        completion(objData, nil)
                    } catch {
                        completion(nil, error)
                    }
                }
            }.resume()
        }
    }
}

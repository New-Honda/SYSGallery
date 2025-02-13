//
//  NetworkManager.swift
//  NewsTime
//
//  Created by Oleksandr Sysenko on 20.04.2022.
//

import Alamofire
import Foundation
import Combine

final class NetworkManager: NetworkManagerProtocol {
    private let defaultHeaders: [String: String] = ["Authorization": "Client-ID RGBf5eVcVR1c5r8FZYBZykeQPpSdPeoaEXELNv2wsfo"]
    private let baseUrl = "https://api.unsplash.com"

    func loadData<T: Decodable>(path: String,
                                method: NetworkManagerMethods = .GET,
                                parameters: [String: Any]) -> AnyPublisher<NetworkManagerResponse<T>, NetworkManagerError> {
        let stringURL: String = baseUrl + path

        guard let urlComponents = URLComponents(string: stringURL) else {
            return Fail(error: .badUrl).eraseToAnyPublisher()
        }

        let headers = HTTPHeaders(defaultHeaders)
        let request = AF.request(urlComponents, method: .init(rawValue: method.rawValue), parameters: parameters, headers: headers).validate(statusCode: 200...299)

        return request.publishDecodable(type: T.self).tryMap {
            // Error checking and handling
            if let afError = $0.error {
                if let failureCode = afError.responseCode {
                    throw NetworkManagerError.httpError(code: failureCode)
                } else if let connectionError = afError.underlyingError as? URLError {
                    switch connectionError.code {
                    case .notConnectedToInternet:
                        throw NetworkManagerError.noInternet
                    case .timedOut, .networkConnectionLost, .cannotConnectToHost:
                        throw NetworkManagerError.connectionFailed
                    default:
                        throw NetworkManagerError.unknown(error: afError.errorDescription)
                    }
                } else if case .responseSerializationFailed = afError {
                    throw NetworkManagerError.badParsing
                } else {
                    throw NetworkManagerError.unknown(error: afError.errorDescription)
                }
            }

            // Model unwraping
            guard let model = $0.value else {
                throw NetworkManagerError.unknown(error: nil)
            }

            // Response model
            let networkManagerResponse = NetworkManagerResponse.init(headers: $0.response?.headers.dictionary ?? [:], model: model)

            return networkManagerResponse
        }.mapError { $0 as? NetworkManagerError ?? .unknown(error: nil) }
        .eraseToAnyPublisher()
    }
}

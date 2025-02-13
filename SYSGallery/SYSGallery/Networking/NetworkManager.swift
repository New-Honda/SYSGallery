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
                                parameters: [String: Any]) -> AnyPublisher<T, NetworkManagerError> {
        let stringURL: String = baseUrl + path

        guard let urlComponents = URLComponents(string: stringURL) else {
            return Fail(error: .badUrl).eraseToAnyPublisher()
        }

        let headers = HTTPHeaders(defaultHeaders.map { HTTPHeader(name: $0, value: $1) })
        let request = AF.request(urlComponents, method: .init(rawValue: method.rawValue), parameters: parameters, headers: headers).validate(statusCode: 200...299)

        return request.publishDecodable(type: T.self).value()
            .receive(on: DispatchQueue.main)
            .mapError({ afError in
                if let failureCode = afError.responseCode {
                    return NetworkManagerError.httpError(code: failureCode)
                } else if let connectionError = afError.underlyingError as? URLError {
                    switch connectionError.code {
                    case .notConnectedToInternet:
                        return .noInternet
                    case .timedOut, .networkConnectionLost, .cannotConnectToHost:
                        return .connectionFailed
                    default:
                        return .unknown(error: afError.errorDescription)
                    }
                } else if case .responseSerializationFailed = afError {
                    return .badParsing
                } else {
                    return .unknown(error: afError.errorDescription)
                }
            })
            .eraseToAnyPublisher()
    }
}

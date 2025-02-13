//
//  NetworkManagerProtocol.swift
//  NewsTime
//
//  Created by Oleksandr Sysenko on 20.04.2022.
//

import Alamofire
import Combine
import Foundation

protocol NetworkManagerProtocol {
    func loadData<T: Decodable>(path: String,
                                method: NetworkManagerMethods,
                                parameters: [String: Any]) -> AnyPublisher<NetworkManagerResponse<T>, NetworkManagerError>
}

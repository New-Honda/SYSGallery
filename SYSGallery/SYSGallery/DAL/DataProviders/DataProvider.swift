//
//  DataProvider.swift
//  SYSGallery
//
//  Created by Oleksandr Sysenko on 13.02.2025.
//

import Combine

protocol DataProvidable {
    func getData<Model: Codable>(from path: ProviderPath, method: NetworkManagerMethods, parameters: [String: Any]) async throws -> Model
}

class DataProvider: DataProvidable {
    private let networkManager: NetworkManagerProtocol

    // MARK: - Init

    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }

    // MARK: - Public

    func getData<Model: Codable>(from path: ProviderPath, method: NetworkManagerMethods, parameters: [String: Any]) async throws -> Model {
        let publisher: AnyPublisher<NetworkManagerResponse<Model>, NetworkManagerError> = networkManager.loadData(path: path.rawValue,
                                                                                                                  method: method,
                                                                                                                  parameters: parameters)
        let response: NetworkManagerResponse<Model> = try await publisher.async()
        let model: Model = handle(response: response)

        return model
    }

    func handle<Model: Codable>(response: NetworkManagerResponse<Model>) -> Model {
        response.model
    }
}

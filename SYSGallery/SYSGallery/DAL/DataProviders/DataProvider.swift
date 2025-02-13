//
//  DataProvider.swift
//  SYSGallery
//
//  Created by Oleksandr Sysenko on 13.02.2025.
//

import Combine

class DataProvider {
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
        let model: Model = try await publisher.async().model
        return model
    }
}

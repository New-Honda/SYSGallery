//
//  DataPagingProvider.swift
//  SYSGallery
//
//  Created by Oleksandr Sysenko on 14.02.2025.
//

enum DataPagingProviderError: Error {
    case requestInProcess
}

class DataPagingProvider: DataProvider {
    private(set) var isLoading: Bool = false
    private(set) var page: Int
    private(set) var perPage: Int
    private(set) var totalCount: Int?

    var canLoadMore: Bool {
        guard let totalCount else { return false }

        return page * perPage < totalCount
    }

    init(page: Int = 1, perPage: Int = 10, networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.page = page
        self.perPage = perPage

        super.init(networkManager: networkManager)
    }

    override func getData<Model: Codable>(from path: ProviderPath,
                                          method: NetworkManagerMethods,
                                          parameters: [String: Any]) async throws -> Model {
        guard !isLoading else { throw DataPagingProviderError.requestInProcess }
        isLoading = true

        var parameters = parameters
        parameters["page"] = page
        parameters["per_page"] = perPage

        let model: Model = try await super.getData(from: path, method: method, parameters: parameters)

        isLoading = false

        return model
    }

    override func handle<Model: Codable>(response: NetworkManagerResponse<Model>) -> Model {
        if let totalField = response.headers["X-Total"],
           let totalCount = Int(totalField) {
            self.totalCount = totalCount
        }

        return super.handle(response: response)
    }

    func setNextPage() {
        guard !isLoading else { return }

        page += 1
    }

    func reset() {
        page = 1
        totalCount = nil
    }
}

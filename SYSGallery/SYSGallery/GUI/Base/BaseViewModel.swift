//
//  BaseViewModel.swift
//  SYSGallery
//
//  Created by Oleksandr Sysenko on 14.02.2025.
//

import Combine

class BaseViewModel: ObservableObject {
    @Published var errorTitle: String?

    func apply<Model: Codable>(dataProvider: DataProvidable,
                               path: ProviderPath,
                               method: NetworkManagerMethods,
                               parameters: [String: Any] = [:]) async -> Model? {
        do {
            return try await dataProvider.getData(from: path, method: method, parameters: parameters)
        } catch let error {
            if let error = error as? NetworkManagerError {
                await MainActor.run {
                    handle(error: error)
                }
            }

            return nil
        }
    }

    func handle(error: NetworkManagerError) {
        switch error {
        case .httpError(let code):
            switch code {
            case 400...499:
                errorTitle = "Something go wrong"
            case 500...599:
                errorTitle = "Server error"
            default:
                errorTitle = "Unknown error"
            }
        case .connectionFailed:
            errorTitle = "Connection error. Try again"
        case .noInternet:
            errorTitle = "No Internet"
        case .badUrl, .badParsing:
            errorTitle = "Something go wrong"
        case .unknown:
            errorTitle = "Unknown error"
        }
    }
}

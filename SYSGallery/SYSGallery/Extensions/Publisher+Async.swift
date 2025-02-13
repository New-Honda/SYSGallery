//
//  Publusher+Async.swift
//  SYSGallery
//
//  Created by Oleksandr Sysenko on 13.02.2025.
//

import Combine

enum AsyncError: Error {
    case finishedWithoutValue
}

extension Publisher {
    func async() async throws -> Output {
        var cancellable: AnyCancellable?
        var finishedWithoutValue = true
        defer { cancellable?.cancel() }
        return try await withCheckedThrowingContinuation { continuation in
            cancellable = sink { result in
                switch result {
                case .finished:
                    if finishedWithoutValue {
                        continuation.resume(throwing: AsyncError.finishedWithoutValue)
                    }
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            } receiveValue: { value in
                finishedWithoutValue = false
                continuation.resume(with: .success(value))
            }
        }
    }
}

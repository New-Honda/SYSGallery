//
//  NetworkManagerError.swift
//  SYSGallery
//
//  Created by Oleksandr Sysenko on 12.02.2025.
//

enum NetworkManagerError: Error {
    case httpError(code: Int)
    case connectionFailed
    case noInternet
    case badUrl
    case badParsing
    case unknown(error: String?)
}

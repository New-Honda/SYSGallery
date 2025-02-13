//
//  NetworkManagerResponse.swift
//  SYSGallery
//
//  Created by Oleksandr Sysenko on 13.02.2025.
//

struct NetworkManagerResponse<ResponseModel: Codable> {
    let headers: [String: String]
    let model: ResponseModel
}

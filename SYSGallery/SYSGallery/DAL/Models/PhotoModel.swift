//
//  PhotoModel.swift
//  SYSGallery
//
//  Created by Oleksandr Sysenko on 14.02.2025.
//

struct PhotoModel: Codable, Identifiable {
    struct PhotoURLs: Codable {
        let thumb: String
        let full: String
    }

    let id: String
    let description: String?
    let photos: PhotoURLs
    let likes: Int
    let user: UserModel

    enum CodingKeys: String, CodingKey {
        case id
        case description
        case photos = "urls"
        case likes
        case user
    }
}

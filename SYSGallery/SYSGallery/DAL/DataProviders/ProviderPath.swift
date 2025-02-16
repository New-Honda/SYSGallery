//
//  ProviderPath.swift
//  SYSGallery
//
//  Created by Oleksandr Sysenko on 13.02.2025.
//

enum ProviderPath {
    case photos
    case user(username: String)

    var path: String {
        switch self {
        case .photos:
            "/photos"
        case .user(let username):
            // darkcatimages
            "/users/\(username)/photos"
        }
    }
}

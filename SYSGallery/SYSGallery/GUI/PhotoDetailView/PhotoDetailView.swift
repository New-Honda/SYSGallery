//
//  PhotoDetailView.swift
//  SYSGallery
//
//  Created by Oleksandr Sysenko on 15.02.2025.
//

import SwiftUI

struct PhotoDetailView: View {
    let photo: PhotoModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncCachedImage(url: URL(string: photo.photos.full), content: { image in
                    image.resizable()
                }, placeholder: {
                    ProgressView().frame(maxWidth: .infinity, maxHeight: 300)
                })
                .scaledToFit().background(.gray)

                VStack(alignment: .leading, spacing: 8) {
                    if let description = photo.description {
                        Text(description)
                            .font(.body)
                            .foregroundColor(.primary)
                    }

                    Text(photo.user.name)
                        .font(.title)
                        .fontWeight(.bold)

                    Text("@\(photo.user.username)")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    if let bio = photo.user.bio {
                        Text(bio)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Post Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    PhotoDetailView(photo: .init(id: "", description: "description",
                                photos: .init(thumb: "", full: ""),
                                likes: 10,
                                user: .init(id: "",
                                            name: "Mike",
                                            username: "miki",
                                            bio: "Bio")))
}

//
//  PhotoRowView.swift
//  SYSGallery
//
//  Created by Oleksandr Sysenko on 14.02.2025.
//

import SwiftUI

struct PhotoRowView: View {
    let image: String
    let description: String?
    let likes: Int
    let author: String

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            AsyncCachedImage(url: URL(string: image), content: { image in
                image.resizable()
            }, placeholder: {
                ProgressView()
            })
            .frame(width: 150, height: 150)
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 8) {
                Text(author)
                    .font(.headline)
                    .foregroundColor(.primary)

                if let description {
                    Text(description)
                        .font(.body)
                        .lineLimit(5)
                        .foregroundColor(.secondary)
                }

                HStack(spacing: 4) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                    Text("\(likes)")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
            }
            Spacer()
        }
    }
}

#Preview {
    PhotoRowView(image: "example_image",
                 description: "This is an example description for a post.",
                 likes: 120,
                 author: "John Doe")
}

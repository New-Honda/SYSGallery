//
//  PhotosListView.swift
//  SYSGallery
//
//  Created by Oleksandr Sysenko on 12.02.2025.
//

import SwiftUI

struct PhotosListView: View {
    @StateObject var viewModel = PhotosListViewModel()

    var body: some View {
        GeometryReader { proxy in
            List {
                ForEach(viewModel.photos) { photoModel in
                    PhotoRowView(image: photoModel.photos.thumb,
                                 description: photoModel.description,
                                 likes: photoModel.likes,
                                 author: photoModel.user.name,
                                 imageWidth: proxy.size.width * 0.3)
                }
                if viewModel.hasMoreData {
                    HStack {
                        Spacer()
                        ProgressView("Loading...")
                        Spacer()
                    }.onAppear {
                        viewModel.getNextPhotoPage()
                    }
                }
            }.onAppear {
                viewModel.getPhotos()
            }
        }
    }
}

#Preview {
    PhotosListView()
}

//
//  PhotosListViewModel.swift
//  SYSGallery
//
//  Created by Oleksandr Sysenko on 14.02.2025.
//

import Combine
import Foundation

final class PhotosListViewModel: BaseViewModel {
    @Published var photos: [PhotoModel] = []

    private let dataProvider = DataPagingProvider()

    var hasMoreData: Bool {
        dataProvider.canLoadMore
    }

    func getPhotos() {
        Task {
            guard let photoModels: [PhotoModel] = await apply(dataProvider: dataProvider, path: .user, method: .GET) else { return }

            await MainActor.run {
                self.photos.append(contentsOf: photoModels)
            }
        }
    }

    func getNextPhotoPage() {
        dataProvider.setNextPage()
        getPhotos()
    }
}

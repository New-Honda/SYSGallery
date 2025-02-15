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

    private func getModel<Model: Codable>() async -> Model? {
        await apply(dataProvider: dataProvider, path: .user, method: .GET)
    }

    func getPhotos() async {
        guard let photoModels: [PhotoModel] = await getModel() else { return }

        await MainActor.run {
            photos.append(contentsOf: photoModels)
        }
    }

    func getNextPhotoPage() async {
        dataProvider.setNextPage()
        await getPhotos()
    }

    func reload() async {
        dataProvider.reset()
        guard let photoModels: [PhotoModel] = await getModel() else { return }

        await MainActor.run {
            photos = photoModels
        }
    }
}

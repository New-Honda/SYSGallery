//
//  SYSGalleryNetworkManagerTests.swift
//  SYSGalleryTests
//
//  Created by Oleksandr Sysenko on 16.02.2025.
//

import XCTest
import Alamofire
import Combine
@testable import SYSGallery

final class SYSGalleryNetworkManagerTests: XCTestCase {

    var networkManager: NetworkManager!
    var cancellable: [AnyCancellable] = []

    // MARK: - Base overrides

    override func setUp() {
        super.setUp()

        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockURLProtocol.self] + (configuration.protocolClasses ?? [])
        networkManager = NetworkManager(session: Session(configuration: configuration))
    }

    override func tearDown() {
        networkManager = nil
        cancellable.removeAll()

        super.tearDown()
    }

    // MARK: - Tests

    func testPhotoReciving() throws {
        let urlPath: String = networkManager.baseUrl + ProviderPath.photos.path

        let mockString = MockBodyResponses.photoResponse

        let mockData: Data = Data(mockString.utf8)

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: try XCTUnwrap(request.url),
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: ["Content-Type": "application/json"])!
            return (response, mockData)
        }

        let publisher: AnyPublisher<NetworkManagerResponse<[PhotoModel]>, NetworkManagerError> = networkManager.loadData(path: urlPath,
                                                                                                                         parameters: [:])
        let expectation = XCTestExpectation(description: "response")
        expectation.expectedFulfillmentCount = 2

        publisher.sink(receiveCompletion: { result in
            switch result {
            case .finished:
                expectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }, receiveValue: { value in
            XCTAssertEqual(value.model.count, 1)
            expectation.fulfill()
        }).store(in: &cancellable)

        wait(for: [expectation], timeout: 2)
    }
}

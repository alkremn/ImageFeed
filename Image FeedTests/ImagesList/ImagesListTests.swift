//
//  ImagesListTests.swift
//  Image FeedTests
//
//  Created by Alexey Kremnev on 1/22/25.
//

import XCTest
@testable import Image_Feed

final class ImagesListTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        _ = viewController.view
        
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsFetchPhotosNextPage() {
        let viewController = ImagesListViewController()
        let imagesListService = ImagesListServiceMock()
        
        let sut = ImagesListPresenter(
            imagesListService: imagesListService,
            oAuth2TokenStorage: OAuth2TokenStorageMock()
        )
        
        viewController.presenter = sut
        sut.view = viewController
        sut.viewDidLoad()
        
        XCTAssertTrue(imagesListService.fetchPhotosNextPageCalled)
    }
    
    func testPresenterCallsUpdateProfileDetails() {
        let viewController = ImagesListViewControllerSpy()
        let sut = ImagesListPresenter(
            imagesListService: ImagesListServiceMock(),
            oAuth2TokenStorage: OAuth2TokenStorageMock()
        )
        
        viewController.presenter = sut
        sut.view = viewController
        
        sut.viewDidLoad()
        
        XCTAssertTrue(viewController.showProgressCalled)
    }
}

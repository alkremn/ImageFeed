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
        
        XCTAssertTrue(presenter.viewDodLoadCalled)
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

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImagesListPresenterProtocol?
    var showProgressCalled = false
    
    func insertTableRows(at idxPaths: [IndexPath]) {
    }
    
    func present(_ viewController: UIViewController) {
    }
    
    func changeImageLikeState(at index: Int, isLiked: Bool) {
    }
    
    func show(alert: Image_Feed.AlertModel) {
    }
    
    func dismissAlert() {
    }
    
    func showProgress() {
        showProgressCalled = true
    }
    
    func hideProgress() {
    }
}


final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var viewDodLoadCalled: Bool = false

    var view: ImagesListViewControllerProtocol?
    
    var photos = [Photo]()
    var imagesCount: Int = 0
    
    func viewDidLoad() {
        viewDodLoadCalled = true
    }
    
    func didSelectRow(at index: Int) {
    }
    
    func didImageLike(at index: Int) {
    }
    
    func willDisplayImage(at index: Int) {
    }
}

final class ImagesListServiceMock: ImagesListServiceProtocol {
    static var didChangeNotification = Notification.Name(rawValue: "Test")
    var photos = [Photo]()
    var fetchPhotosNextPageCalled = false
    
    func fetchPhotosNextPage(token: String) {
        fetchPhotosNextPageCalled = true
    }
    
    func changeLike(photoId: String, isLiked: Bool, completion: @escaping (Result<Void, any Error>) -> Void) {
    }
    
    func clear() {
    }
}

final class OAuth2TokenStorageMock: OAuth2TokenStorageProtocol {
    var token: String? = "test token"
    
    func removeToken() {
    }
}



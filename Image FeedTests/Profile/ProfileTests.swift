//
//  ProfileTests.swift
//  Image FeedTests
//
//  Created by Alexey Kremnev on 1/22/25.
//

import XCTest
@testable import Image_Feed

final class ProfileTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        _ = viewController.view
        
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsSetProfileImage() {
        let viewController = ProfileViewControllerSpy()
        let sut = ProfilePresenter(
            profileService: ProfileServiceMock(),
            profileImageService: ProfileImageServiceMock(),
            profileLogoutService: ProfileLogoutServiceMock())
        
        viewController.presenter = sut
        sut.view = viewController
        sut.viewDidLoad()
        
        XCTAssertTrue(viewController.isSetProfileImageCalled)
    }
    
    func testPresenterCallsUpdateProfileDetails() {
        let viewController = ProfileViewControllerSpy()
        let sut = ProfilePresenter(
            profileService: ProfileServiceMock(),
            profileImageService: ProfileImageServiceMock(),
            profileLogoutService: ProfileLogoutServiceMock())
        
        viewController.presenter = sut
        sut.view = viewController
        sut.viewDidLoad()
        
        XCTAssertTrue(viewController.isUpdateProfileDetailsCalled)
    }
}

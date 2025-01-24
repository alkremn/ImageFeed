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
        
        XCTAssertTrue(presenter.viewDodLoadCalled)
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

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    
    var view: ProfileViewControllerProtocol?
    var viewDodLoadCalled: Bool = false
    
    func viewDidLoad() {
        viewDodLoadCalled = true
    }

    func didLogoutRequest() {}
}


final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var isSetProfileImageCalled = false
    var isUpdateProfileDetailsCalled = false
    
    var presenter: ProfilePresenterProtocol?
    
    func setProfileImage(with url: URL) {
        isSetProfileImageCalled = true
    }
    
    func updateProfileDetails(with profile: Profile) {
        isUpdateProfileDetailsCalled = true
    }
    
    func show(alert: AlertModel) {
    }
    
    func didAlertDismiss() {
    }
    
    func didRedirect(to controller: UIViewController) {
    }
}

final class ProfileServiceMock: ProfileServiceProtocol {
    var profile: Profile? = Profile(username: "", name: "", loginName: "", bio: "")
    
    func fetchProfile(token: String, completion: @escaping (Result<Image_Feed.Profile, any Error>) -> Void) {
    }
    
    func clear() {
    }
}

final class ProfileImageServiceMock: ProfileImageServiceProtocol {
    static var didChangeNotification = Notification.Name(rawValue: "Test")
    
    var avatarURL: String? = "test_url"
    
    func fetchProfileImageURL(token: String, username: String, _ completion: @escaping (Result<String, any Error>) -> Void) {
    }
    
    func clear() {
    }
}

final class ProfileLogoutServiceMock: ProfileLogoutServiceProtocol {
    
    func logout() {
    }
}

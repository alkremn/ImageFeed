//
//  ProfileViewControllerSpy.swift
//  ImageFeed
//
//  Created by Alexey Kremnev on 1/25/25.
//

import XCTest
@testable import Image_Feed

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
    
    func dismissAlert() {
    }
    
    func redirect(to controller: UIViewController) {
    }
}

//
//  ProfilePresenterSpy.swift
//  ImageFeed
//
//  Created by Alexey Kremnev on 1/25/25.
//

import XCTest
@testable import Image_Feed

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    
    var view: ProfileViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func didTapLogoutButton() {}
}

//
//  ProfileImageServiceMock.swift
//  ImageFeed
//
//  Created by Alexey Kremnev on 1/25/25.
//

import XCTest
@testable import Image_Feed

final class ProfileImageServiceMock: ProfileImageServiceProtocol {
    static var didChangeNotification = Notification.Name(rawValue: "Test")
    
    var avatarURL: String? = "test_url"
    
    func fetchProfileImageURL(token: String, username: String, _ completion: @escaping (Result<String, any Error>) -> Void) {
    }
    
    func clear() {
    }
}

//
//  ProfileServiceMock.swift
//  ImageFeed
//
//  Created by Alexey Kremnev on 1/25/25.
//

import XCTest
@testable import Image_Feed

final class ProfileServiceMock: ProfileServiceProtocol {
    var profile: Profile? = Profile(username: "", name: "", loginName: "", bio: "")
    
    func fetchProfile(token: String, completion: @escaping (Result<Image_Feed.Profile, any Error>) -> Void) {
    }
    
    func clear() {
    }
}

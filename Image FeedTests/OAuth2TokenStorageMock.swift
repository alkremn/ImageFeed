//
//  OAuth2TokenStorageMock.swift
//  ImageFeed
//
//  Created by Alexey Kremnev on 1/25/25.
//

import XCTest
@testable import Image_Feed

final class OAuth2TokenStorageMock: OAuth2TokenStorageProtocol {
    var token: String? = "test token"
    
    func removeToken() {
    }
}

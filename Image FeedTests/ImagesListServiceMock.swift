//
//  ImagesListServiceMock.swift
//  ImageFeed
//
//  Created by Alexey Kremnev on 1/25/25.
//

import XCTest
@testable import Image_Feed

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

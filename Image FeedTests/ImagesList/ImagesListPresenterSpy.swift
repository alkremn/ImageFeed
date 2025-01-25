//
//  ImagesListPresenterSpy.swift
//  ImageFeed
//
//  Created by Alexey Kremnev on 1/25/25.
//

import XCTest
@testable import Image_Feed

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var viewDidLoadCalled: Bool = false

    var view: ImagesListViewControllerProtocol?
    
    var photos = [Photo]()
    var imagesCount: Int = 0
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didSelectRow(at index: Int) {
    }
    
    func didTapImageLikeButton(at index: Int) {
    }
    
    func willDisplayImage(at index: Int) {
    }
}

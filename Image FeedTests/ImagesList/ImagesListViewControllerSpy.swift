//
//  ImagesListViewControllerSpy.swift
//  ImageFeed
//
//  Created by Alexey Kremnev on 1/25/25.
//

import XCTest
@testable import Image_Feed

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

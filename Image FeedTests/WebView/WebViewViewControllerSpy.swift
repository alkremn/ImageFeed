//
//  WebViewViewControllerSpy.swift
//  ImageFeed
//
//  Created by Alexey Kremnev on 1/25/25.
//

import XCTest
@testable import Image_Feed

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var isLoadRequestCalled = false
    var presenter: (any Image_Feed.WebViewPresenterProtocol)?
    
    func load(request: URLRequest) {
        isLoadRequestCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
    }
    
    func setProgressHidden(_ isHidden: Bool) {
    }
}

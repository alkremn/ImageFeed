//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Alexey Kremnev on 1/21/25.
//

import Foundation


protocol WebViewPresenterProtocol: AnyObject {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}

final class WebViewPresenter: WebViewPresenterProtocol {
    weak var view: WebViewViewControllerProtocol?
    
    var authHelper: AuthHelperProtocol
    
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
        
    func viewDidLoad() {
        guard let request = authHelper.authRequest() else { return }
        
        view?.load(request: request)
        view?.setProgressValue(0)
    }
    
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        let isHidden = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(isHidden)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
}

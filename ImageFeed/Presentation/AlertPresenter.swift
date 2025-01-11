//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Alexey Kremnev on 1/7/25.
//

import UIKit


final class AlertPresenter {
    
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    func show(title: String?, message: String?, actions: [UIAlertAction]) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        actions.forEach({alert.addAction($0)})
        viewController?.present(alert, animated: true)
    }
}

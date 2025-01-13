//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Alexey Kremnev on 1/7/25.
//

import UIKit


final class AlertPresenter {
        
    static func show(title: String?, message: String?, actions: [UIAlertAction], viewController: UIViewController?) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        actions.forEach({alert.addAction($0)})
        alert.preferredAction = actions.last
        viewController?.present(alert, animated: true)
    }
}

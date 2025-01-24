//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Alexey Kremnev on 1/7/25.
//

import UIKit

final class AlertPresenter {
    
    static weak var viewController: UIViewController?
    
    static func show(_ viewController: UIViewController, alertModal: AlertModel) {
        let alert = UIAlertController(
            title: alertModal.title,
            message: alertModal.message,
            preferredStyle: .alert
        )
        
        alertModal.actions.forEach { action in
            let alertAction = UIAlertAction(title: action.buttonText, style: .default) { _ in
                action.completion()
            }
            alert.addAction(alertAction)
            if action.isPreferred {
                alert.preferredAction = alertAction
            }
        }
        
        alert.view.accessibilityIdentifier = "Alert"
        viewController.present(alert, animated: true, completion: nil)
    }
}

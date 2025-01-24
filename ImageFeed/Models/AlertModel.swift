//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Alexey Kremnev on 1/22/25.
//

import UIKit

struct AlertModel {
    let title: String
    let message: String?
    let actions: [AlertAction]
}

struct AlertAction {
    let buttonText: String
    let isPreferred: Bool
    let completion: () -> Void
    
    init(buttonText: String, isPreferred: Bool = false, completion: @escaping () -> Void) {
        self.buttonText = buttonText
        self.isPreferred = isPreferred
        self.completion = completion
    }
}

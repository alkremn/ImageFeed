//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Alexey Kremnev on 12/2/24.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    
    static func setup() {
        ProgressHUD.animationType = .activityIndicator
        ProgressHUD.colorHUD = .ypBlack
        ProgressHUD.colorAnimation = .lightGray
    }
    
    private static var window: UIWindow? {
        UIApplication.shared.windows.first
    }
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.animate()
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.remove()
    }
}

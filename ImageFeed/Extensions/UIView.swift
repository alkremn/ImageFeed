//
//  UIView.swift
//  ImageFeed
//
//  Created by Alexey Kremnev on 11/14/24.
//

import UIKit


extension UIView {
    func addSubViews(_ views: UIView...) {
        views.forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        })
    }
}

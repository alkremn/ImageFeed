//
//  UILabel+Ext.swift
//  ImageFeed
//
//  Created by Alexey Kremnev on 11/14/24.
//

import UIKit


extension UILabel {
    convenience init(text: String = "", font: UIFont, textColor: UIColor) {
        self.init()
        self.text = text
        self.font = font
        self.textColor = textColor
    }
}

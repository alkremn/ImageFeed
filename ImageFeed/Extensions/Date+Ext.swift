//
//  Date+Ext.swift
//  ImageFeed
//
//  Created by Alexey Kremnev on 11/2/24.
//

import Foundation


extension Date {
    var stringRepresentation: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        
        return formatter.string(from: self)
    }
}

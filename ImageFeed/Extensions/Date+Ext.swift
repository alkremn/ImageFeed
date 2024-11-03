//
//  Date+Ext.swift
//  ImageFeed
//
//  Created by Alexey Kremnev on 11/2/24.
//

import Foundation

extension Date {
    
    private static let sharedFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    var stringRepresentation: String { Date.sharedFormatter.string(from: self) }
}

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
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    private static let sharedISODateFormatter: ISO8601DateFormatter = ISO8601DateFormatter()
        
    static func getDate(from: String?) -> Date? {
        sharedISODateFormatter.date(from: from ?? "")
    }
    
    var stringRepresentation: String { Date.sharedFormatter.string(from: self) }
}

extension Int {
    var number: Int { return self }
}

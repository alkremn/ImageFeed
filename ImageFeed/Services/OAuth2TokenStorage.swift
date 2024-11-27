//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Alexey Kremnev on 11/23/24.
//

import Foundation

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    
    private init() {}
    
    private let storage = UserDefaults.standard
    
    private enum Keys: String {
        case bearerToken
    }
    
    var token: String? {
        get {
            storage.string(forKey: Keys.bearerToken.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.bearerToken.rawValue)
        }
    }
}

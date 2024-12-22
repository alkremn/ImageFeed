//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Alexey Kremnev on 11/23/24.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    
    private init() {}
    
    private let keychain = KeychainWrapper.standard
    
    private enum Keys: String {
        case bearerToken
    }
    
    var token: String? {
        get {
            keychain.string(forKey: Keys.bearerToken.rawValue)
        }
        set {
            guard let newValue else { return }
            keychain.set(newValue, forKey: Keys.bearerToken.rawValue)
        }
    }
    
    func removeToken() {
        keychain.removeObject(forKey: Keys.bearerToken.rawValue)
    }
}

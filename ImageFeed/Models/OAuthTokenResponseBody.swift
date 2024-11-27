//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Alexey Kremnev on 11/23/24.
//

import Foundation


struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Date
}

//
//  UrlsResult.swift
//  ImageFeed
//
//  Created by Alexey Kremnev on 1/3/25.
//

import Foundation

struct PhotoResult: Decodable {
    let id: String
    let width: Int
    let height: Int
    let description: String?
    let likedByUser: Bool
    let createdAt: String?
    let urls: UrlsResult
}

struct UrlsResult: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

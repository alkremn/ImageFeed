//
//  Photo.swift
//  ImageFeed
//
//  Created by Alexey Kremnev on 1/3/25.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

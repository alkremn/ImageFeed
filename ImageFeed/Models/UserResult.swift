//
//  UserResult.swift
//  ImageFeed
//
//  Created by Alexey Kremnev on 12/4/24.
//

import Foundation

struct UserResult: Decodable {
    let profileImage: ProfileImage
}

struct ProfileImage: Decodable {
    let small: String
    let medium: String
}

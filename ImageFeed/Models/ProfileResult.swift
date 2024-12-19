//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Alexey Kremnev on 12/2/24.
//

import Foundation


struct ProfileResult: Decodable {
    let id: String
    let username: String
    let firstName: String
    let lastName: String
    let bio: String?
}

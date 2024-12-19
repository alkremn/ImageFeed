//
//  Constants.swift
//  ImageFeed
//
//  Created by Alexey Kremnev on 11/17/24.
//

import Foundation

enum Constants {
    static let accessKey = "DPXW3fDDpwRFP1oIdLDofPerwAMzp-C5Vun0DuRKt6M"
    static let secretKey = "TG4ayWHocCU5NmIPgOc8irIPUzsWlmuw_dAPNWhrBHI"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL: URL? = URL(string: "https://api.unsplash.com")
}

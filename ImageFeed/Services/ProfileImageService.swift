//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Alexey Kremnev on 12/4/24.
//

import Foundation

protocol ProfileImageServiceProtocol {
    static var didChangeNotification: Notification.Name { get }
    var avatarURL: String? { get }
    
    func fetchProfileImageURL(token: String, username: String, _ completion: @escaping (Result<String, Error>) -> Void)
    func clear()
}

enum ProfileImageServiceError: Error {
    case decodeFailure
    case fetchDataFailure
}

final class ProfileImageService: ProfileImageServiceProtocol {

    static let shared = ProfileImageService()
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    private(set) var avatarURL: String?
    
    private var task: URLSessionTask?
    
    private init() {}
    
    func fetchProfileImageURL(token: String, username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        guard let request = createProfileImageRequest(with: token, username: username) else { return }
        
        if task != nil {
            task?.cancel()
        }
        
        task = URLSession.shared.objectTask(
            for: request,
            completion: { [weak self] (result: Result<UserResult, Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let userResult):
                let profileImageUrl = userResult.profileImage.medium
                self.avatarURL = profileImageUrl
                completion(.success(profileImageUrl))
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": profileImageUrl]
                    )
            case .failure(let error):
                print("[fetchProfileImageURL]: NetworkError - \(error.localizedDescription)")
            }
        })
        
        task?.resume()
    }
    
    func clear() {
        task?.cancel()
        avatarURL = nil
    }
    
    private func createProfileImageRequest(with token: String, username: String) -> URLRequest? {
        var url = Constants.defaultBaseURL
        
        if #available(iOS 16, *) {
            url = url.appending(path: "/users/\(username)")
        } else {
            url = url.appendingPathComponent("/users/\(username)")
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}

//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Alexey Kremnev on 12/2/24.
//

import Foundation

enum ProfileServiceError: Error {
    case invalidRequest
}

final class ProfileService {
    
    static let shared = ProfileService()
    
    private init() {}
    
    private(set) var profile: Profile?
    
    private var task: URLSessionTask?
    
    func fetchProfile(token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        
        guard let request = createProfileURLRequest(with: token) else {
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }
        
        if task != nil {
            task?.cancel()
        }
        
        task = URLSession.shared.objectTask(for: request) { (result: Result<ProfileResult, Error>) in
            switch result {
            case .success(let profileResult):
                let profile = self.convert(from: profileResult)
                self.profile = profile
                completion(.success(profile))
            case .failure(let error):
                print("failed to get data with error: \(error)")
                completion(.failure(error))
            }
        }
        
        task?.resume()
    }
    
    private func createProfileURLRequest(with token: String) -> URLRequest? {
        guard var url = Constants.defaultBaseURL else {
            print("Base url does not exist")
            return nil
        }
        
        if #available(iOS 16, *) {
            url = url.appending(path: "/me")
        } else {
            url = url.appendingPathComponent("/me")
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    private func convert(from result: ProfileResult) -> Profile {
        return .init(
            username: result.username,
            name: "\(result.firstName) \(result.lastName)",
            loginName: result.username,
            bio: result.bio
        )
    }
}

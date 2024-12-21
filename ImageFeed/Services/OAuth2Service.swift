//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Alexey Kremnev on 11/22/24.
//

import Foundation

enum AuthServiceError: Error {
    case invalidRequest
}

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    
    private init() {}
    
    private let baseOAuth2Url = "https://unsplash.com"
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard lastCode != code else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        task?.cancel()
        lastCode = code
        
        guard let request = createOAuthTokenRequest(code: code) else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        task = URLSession.shared.objectTask(for: request) { (result: Result<OAuthTokenResponseBody, Error>) in
            switch result {
            case .success(let authResponse):
                OAuth2TokenStorage.shared.token = authResponse.accessToken
                completion(.success(authResponse.accessToken))
            case .failure(let error):
                print("[OAuth2Service]: NetworkError - \(error.localizedDescription)")
            }
        }
        
        task?.resume()
    }
    
    private func createOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: baseOAuth2Url + "/oauth/token") else {
            print("[createOAuthTokenRequest]: URLError - Unable to create url components")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents.url else {
            print("[createOAuthTokenRequest]: URLError - Unable to retrieve url from url components")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        return request
    }
}

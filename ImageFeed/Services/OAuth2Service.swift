//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Alexey Kremnev on 11/22/24.
//

import Foundation

final class OAuth2Service {
    
    static let shared = OAuth2Service()

    private init() {}
    
    private let baseOAuth2Url = "https://unsplash.com"
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        let request = createOAuthToken(code: code)
        guard let request else { return }
        
        URLSession.shared.data(for: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let authResponse = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    OAuth2TokenStorage.shared.token = authResponse.accessToken
                    completion(.success(authResponse.accessToken))
                } catch {
                    print("Unable to decode data with error: \(error)")
                }
            case .failure(let error):
                print("failed to get data with error: \(error)")
            }
        }.resume()
    }
    
    private func createOAuthToken(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: baseOAuth2Url + "/oauth/token") else {
            print("Unable to create url components")
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
            print("Unable to retrieve url from url components")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        return request
    }
}

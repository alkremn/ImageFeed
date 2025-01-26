//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Alexey Kremnev on 1/3/25.
//

import Foundation

protocol ImagesListServiceProtocol: AnyObject {
    static var didChangeNotification: Notification.Name { get }
    var photos: [Photo] { get }
    
    func fetchPhotosNextPage(token: String)
    func changeLike(photoId: String, isLiked: Bool, completion: @escaping (Result<Void, Error>) -> Void)
    func clear()
}

final class ImagesListService: ImagesListServiceProtocol {
    
    static let shared = ImagesListService()
    
    private init() {}
    
    private(set) var photos: [Photo] = []
    
    private var lastLoadedPage: Int?
    private var imagesTask: URLSessionTask?
    private var likeTask: URLSessionTask?
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    func fetchPhotosNextPage(token: String) {
        if imagesTask != nil {
            return
        }
        
        let nextPage = (lastLoadedPage?.number ?? 0) + 1
        guard let request = createImageListRequest(with: token,  pageNumber: nextPage) else { return }
        
        imagesTask = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let photoResult):
                self.lastLoadedPage = nextPage
                self.photos.append(contentsOf: photoResult.map({ self.convertPhotoResultToPhoto(photoResult: $0)}))
                NotificationCenter.default
                    .post(
                        name: ImagesListService.didChangeNotification,
                        object: self,
                        userInfo: nil
                    )
                
            case .failure(let error):
                print("[fetchPhotosNextPage] - NetworkError with error: \(error)")
            }
            imagesTask = nil
        }
        
        imagesTask?.resume()
    }
    
    func changeLike(photoId: String, isLiked: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let token = OAuth2TokenStorage.shared.token,
              var request = createChangeLikeRequest(with: token, photoId: photoId) else {
            return
        }
        
        request.httpMethod = isLiked ? "POST" : "DELETE"
        
        likeTask = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<LikeResult, Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let likeResult):
                let photoResult = likeResult.photo
                if let idx = self.photos.firstIndex(where: { $0.id == photoResult.id}) {
                    self.photos[idx] = convertPhotoResultToPhoto(photoResult: photoResult)
                }
                completion(.success(()))
            case .failure(let error):
                print("[changeLike] - NetworkError with error: \(error)")
                completion(.failure(error))
            }
        }
        
        likeTask?.resume()
    }
    
    func clear() {
        photos = []
        lastLoadedPage = 0
        imagesTask?.cancel()
        likeTask?.cancel()
        
    }
    
    private func createImageListRequest(with token: String, pageNumber: Int) -> URLRequest? {
        guard var urlComponents = URLComponents(url: Constants.defaultBaseURL, resolvingAgainstBaseURL: true)
        else {
            print("[createImageListRequest]: URLError - Base url does not exist")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: String(pageNumber))
        ]
        
        guard var url = urlComponents.url else {
            print("[createImageListRequest]: URLError - Unable to retrieve url from url components")
            return nil
        }
        
        if #available(iOS 16, *) {
            url = url.appending(path: "/photos")
        } else {
            url = url.appendingPathComponent("/photos")
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    private func createChangeLikeRequest(with token: String, photoId: String) -> URLRequest? {
        var url = Constants.defaultBaseURL
        
        if #available(iOS 16, *) {
            url = url.appending(path: "/photos/\(photoId)/like")
        } else {
            url = url.appendingPathComponent("/photos/\(photoId)/like")
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    private func convertPhotoResultToPhoto(photoResult: PhotoResult) -> Photo {
        return .init(
            id: photoResult.id,
            size: CGSize(width: photoResult.width, height: photoResult.height),
            createdAt: Date.getDate(from: photoResult.createdAt),
            welcomeDescription: photoResult.description,
            thumbImageURL: photoResult.urls.thumb,
            largeImageURL: photoResult.urls.full,
            isLiked: photoResult.likedByUser
        )
    }
}

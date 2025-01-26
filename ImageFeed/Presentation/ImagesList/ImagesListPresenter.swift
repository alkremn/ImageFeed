//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Alexey Kremnev on 1/22/25.
//

import Foundation

protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get }
    var imagesCount: Int { get }
    func viewDidLoad()
    func didSelectRow(at index: Int)
    func didTapImageLikeButton(at index: Int)
    func willDisplayImage(at index: Int)
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    var imagesCount: Int { photos.count }
    var photos = [Photo]()
    
    private let imagesListService: ImagesListServiceProtocol
    private let oAuth2TokenStorage: OAuth2TokenStorageProtocol
    private var imageListServiceObserver: NSObjectProtocol?
    
    init(imagesListService: ImagesListServiceProtocol, oAuth2TokenStorage: OAuth2TokenStorageProtocol) {
        self.imagesListService = imagesListService
        self.oAuth2TokenStorage = oAuth2TokenStorage
    }
    
    func viewDidLoad() {
        imageListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { _ in
                self.updateTableViewAnimated()
            }
        
        guard let token = oAuth2TokenStorage.token else { return }
        imagesListService.fetchPhotosNextPage(token: token)
        
        view?.showProgress()
    }
    
    func didSelectRow(at index: Int) {
        let imageUrlString = photos[index].largeImageURL
        
        guard let imageUrl = URL(string: imageUrlString) else {
            print("[ImagesListPresenter] - URLError: Unable to create image URL")
            return
        }
        
        let singleImageVC = SingleImageViewController()
        singleImageVC.modalPresentationStyle = .fullScreen
        singleImageVC.configure(imageUrl: imageUrl)
        view?.present(singleImageVC)
    }
    
    func didTapImageLikeButton(at index: Int) {
        view?.showProgress()
        let photo = photos[index]
        imagesListService.changeLike(photoId: photo.id, isLiked: !photo.isLiked) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success:
                self.photos = ImagesListService.shared.photos
                view?.changeImageLikeState(at: index, isLiked: self.photos[index].isLiked)
            case .failure:
                showFailureAlert()
            }
            
            view?.hideProgress()
        }
    }
    
    func willDisplayImage(at index: Int) {
        guard let token = OAuth2TokenStorage.shared.token,
              index + 1 == photos.count else { return }
        
        imagesListService.fetchPhotosNextPage(token: token)
    }
    
    func getImageSize(at index: Int) -> CGSize {
        photos[index].size
    }
    
    private func updateTableViewAnimated() {
        let startIdx = photos.count
        photos = ImagesListService.shared.photos
        let idxPaths = (startIdx..<photos.count).map { IndexPath(row: $0, section: 0)}
        view?.hideProgress()
        view?.insertTableRows(at: idxPaths)
    }
    
    private func showFailureAlert() {
        let alertModel = AlertModel(
            title: "Что-то пошло не так(",
            message: "Запрос не удался",
            actions: [
                AlertAction(buttonText: "OK") { [weak self] in
                    self?.view?.dismissAlert()
                }
            ])
        
        view?.show(alert: alertModel)
    }
}

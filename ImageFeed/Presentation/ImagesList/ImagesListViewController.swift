//
//  ViewController.swift
//  ImageFeed
//
//  Created by Alexey Kremnev on 11/1/24.
//

import UIKit

final class ImagesListViewController: UIViewController {
    
    private lazy var alertPresenter: AlertPresenter = AlertPresenter(viewController: self)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 200
        tableView.backgroundColor = .ypBlack
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        return tableView
    }()
    
    private var imageListServiceObserver: NSObjectProtocol?
    private var photos = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        imageListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                self?.updateTableViewAnimated()
            }
        guard let token = OAuth2TokenStorage.shared.token else { return }
        ImagesListService.shared.fetchPhotosNextPage(token: token)
        UIBlockingProgressHUD.show()
    }
    
    private func updateTableViewAnimated() {
        UIBlockingProgressHUD.dismiss()
        let startIdx = photos.count
        photos = ImagesListService.shared.photos
        tableView.performBatchUpdates {
            let idxPaths = (startIdx..<photos.count).map { IndexPath(row: $0, section: 0)}
            tableView.insertRows(at: idxPaths, with: .automatic)
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .ypBlack
        view.addSubViews(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource extensions

extension ImagesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let imageViewCell = tableView.dequeueReusableCell(
            withIdentifier: ImagesListCell.reuseIdentifier,
            for: indexPath) as? ImagesListCell else { return UITableViewCell() }
        
        imageViewCell.selectionStyle = .none
        configureCell(for: imageViewCell, indexPath: indexPath)
        return imageViewCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let token = OAuth2TokenStorage.shared.token,
            indexPath.row + 1 == ImagesListService.shared.photos.count else { return }
        
        ImagesListService.shared.fetchPhotosNextPage(token: token)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let imageUrlString = photos[indexPath.row].largeImageURL
        
        guard let imageUrl = URL(string: imageUrlString) else {
            print("[tableView] - URLError: Unable to create image URL")
            return
        }
        
        let singleImageVC = SingleImageViewController()
        singleImageVC.modalPresentationStyle = .fullScreen
        singleImageVC.configure(imageUrl: imageUrl)
        present(singleImageVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photoData = photos[indexPath.row]
        let imageInserts = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let cellWidth = tableView.bounds.width - imageInserts.left - imageInserts.right
        let imageSizeRatio = cellWidth / photoData.size.width
        
        return photoData.size.height * imageSizeRatio + imageInserts.top + imageInserts.bottom
    }
    
    private func configureCell(for cell: ImagesListCell, indexPath: IndexPath) {
        let photoData = photos[indexPath.row]
        
        guard let url = URL(string: photoData.thumbImageURL) else {
            assertionFailure("[configureCell]: InitializationError - Unable to create image url \(photoData.thumbImageURL) or button image.")
            return
        }
        
        cell.configure(imageUrl: url, date: photoData.createdAt, isLiked: photoData.isLiked) { [weak self] in
            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        cell.delegate = self
    }
}

//MARK: - ImagesListCellDelegate extension

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellLikeButtonDidTap(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        ImagesListService.shared.changeLike(photoId: photo.id, isLiked: !photo.isLiked) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success:
                self.photos = ImagesListService.shared.photos
                cell.setIsLiked(isLiked: self.photos[indexPath.row].isLiked)
                
            case .failure:
                alertPresenter.show(
                    title: "Что-то пошло не так(",
                    message: "Запрос не удался",
                    actions: [
                        UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                            self?.dismiss(animated: true)
                        }
                ])
                break
            }
            
            UIBlockingProgressHUD.dismiss()
        }
    }
}

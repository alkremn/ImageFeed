//
//  ViewController.swift
//  ImageFeed
//
//  Created by Alexey Kremnev on 11/1/24.
//

import UIKit

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    func insertTableRows(at idxPaths: [IndexPath])
    func present(_ viewController: UIViewController)
    func changeImageLikeState(at index: Int, isLiked: Bool)
    func show(alert: AlertModel)
    func dismissAlert()
    func showProgress()
    func hideProgress()
}

final class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol {
    
    weak var presenter: ImagesListPresenterProtocol?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        presenter?.viewDidLoad()
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
    
    func insertTableRows(at idxPaths: [IndexPath]) {
        tableView.performBatchUpdates {
            tableView.insertRows(at: idxPaths, with: .automatic)
        }
    }
    
    func present(_ viewController: UIViewController) {
        present(viewController, animated: true)
    }
    
    func changeImageLikeState(at index: Int, isLiked: Bool) {
        guard let imageViewCell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
                as? ImagesListCell else { return }
        
        imageViewCell.setIsLiked(isLiked: isLiked)
    }
    
    func show(alert: AlertModel) {
        AlertPresenter.show(self, alertModal: alert)
    }
    
    func dismissAlert() {
        dismiss(animated: true)
    }
    
    func showProgress() {
        UIBlockingProgressHUD.show()
    }
    
    func hideProgress() {
        UIBlockingProgressHUD.dismiss()
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource extensions

extension ImagesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.imagesCount ?? 0
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
        presenter?.willDisplayImage(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        presenter?.didSelectRow(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let photoData = presenter?.photos[indexPath.row] else { return 0.0 }
    
        let imageInserts = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let cellWidth = tableView.bounds.width - imageInserts.left - imageInserts.right
        let imageSizeRatio = cellWidth / photoData.size.width
        
        return photoData.size.height * imageSizeRatio + imageInserts.top + imageInserts.bottom
    }
    
    private func configureCell(for cell: ImagesListCell, indexPath: IndexPath) {
        guard let photoData = presenter?.photos[indexPath.row] else { return }
        
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
        presenter?.didTapImageLikeButton(at: indexPath.row)
    }
}

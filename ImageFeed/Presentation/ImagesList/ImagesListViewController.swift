//
//  ViewController.swift
//  ImageFeed
//
//  Created by Alexey Kremnev on 11/1/24.
//

import UIKit

final class ImagesListViewController: UIViewController {
    
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
    
    private let imageNames: [String] = Array(0..<20).map{"\($0)"}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        configureUI()
    }
    
    private func configureUI() {
        view.addSubViews(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

//MARK: - ImagesListViewController Extensions

extension ImagesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        imageNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let imageViewCell = tableView.dequeueReusableCell(
            withIdentifier: ImagesListCell.reuseIdentifier,
            for: indexPath) as? ImagesListCell else { return UITableViewCell() }
        
        imageViewCell.selectionStyle = .none
        configureCell(for: imageViewCell, indexPath: indexPath)
        
        return imageViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let singleImageVC = SingleImageViewController()
        singleImageVC.image = UIImage(named: imageNames[indexPath.row])
        singleImageVC.modalPresentationStyle = .fullScreen
        present(singleImageVC, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageName = imageNames[indexPath.row]
        guard let image = UIImage(named: imageName) else {
            assertionFailure("[tableView]: InitializationError Unable to create image with name \(imageName)")
            return 0
        }
        
        let imageInserts = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let cellWidth = tableView.bounds.width - imageInserts.left - imageInserts.right
        let imageSizeRatio = cellWidth / image.size.width
    
        return image.size.height * imageSizeRatio + imageInserts.top + imageInserts.bottom
    }
    
    private func configureCell(for cell: ImagesListCell, indexPath: IndexPath) {
        let imageName = imageNames[indexPath.row]
        let isLiked = indexPath.row % 2 == 0
        
        guard let image = UIImage(named: imageName),
            let likeImage = UIImage(named: isLiked ? "active" : "not_active") else {
            assertionFailure("[configureCell]: InitializationError - Unable to create image with name \(imageName) or button image.")
            return
        }
        
        cell.configure(image: image, date: Date().stringRepresentation, likeImageButton: likeImage)
    }
}

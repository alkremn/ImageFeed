//
//  ViewController.swift
//  ImageFeed
//
//  Created by Alexey Kremnev on 11/1/24.
//

import UIKit

final class ImagesListViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    private let imageNames: [String] = Array(0..<20).map{"\($0)"}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = 200
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
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
        configCell(for: imageViewCell, indexPath: indexPath)
        
        return imageViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageName = imageNames[indexPath.row]
        guard let image = UIImage(named: imageName) else {
            assertionFailure("Unable to create image with name \(imageName)")
            return 0
        }
        
        let imageInserts = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let cellWidth = tableView.bounds.width - imageInserts.left - imageInserts.right
        let imageSizeRatio = cellWidth / image.size.width
    
        return image.size.height * imageSizeRatio + imageInserts.top + imageInserts.bottom
    }
    
    private func configCell(for cell: ImagesListCell, indexPath: IndexPath) {
        let imageName = imageNames[indexPath.row]
        let isLiked = indexPath.row % 2 == 0
        
        guard let image = UIImage(named: imageName),
            let likeImage = UIImage(named: isLiked ? "Active" : "No Active") else {
            assertionFailure("Unable to create image with name \(imageName) or button image.")
            return
        }
        
        cell.configure(image: image, date: Date().stringRepresentation, likeImageButton: likeImage)
    }
}

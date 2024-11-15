//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Alexey Kremnev on 11/1/24.
//

import UIKit

final class ImagesListCell: UITableViewCell {

    static let reuseIdentifier = "ImagesListCell"

    @IBOutlet private weak var cellContainerView: UIView!
    @IBOutlet private weak var cellImageView: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var gradientView: UIView!
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellContainerView.layer.cornerRadius = 16
        cellContainerView.layer.masksToBounds = true
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: layer.frame.width, height: gradientView.bounds.height)
        gradient.colors = [UIColor.ypBlack.withAlphaComponent(0).cgColor, UIColor.ypBlack.withAlphaComponent(0.2).cgColor]
        
        gradientView.layer.insertSublayer(gradient, at: 0)
    }
    
    
    func configure(image: UIImage, date: String, likeImageButton: UIImage) {
        cellImageView.image = image
        dateLabel.text = date
        likeButton.setImage(likeImageButton, for: .normal)
    }
    
    
    @IBAction private func likeButtonTap(_ sender: Any) {
    }
}

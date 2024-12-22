//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Alexey Kremnev on 11/1/24.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImagesListCell"
    
    private lazy var cellImageView: UIImageView = { UIImageView() }()
    private lazy var dateLabel: UILabel = {
        UILabel(text: "", font: .systemFont(ofSize: 13, weight: .regular), textColor: .ypWhite)
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(likeButtonTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var gradientView: UIView = {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: layer.frame.width, height: 30)
        gradient.colors = [UIColor.ypBlack.withAlphaComponent(0).cgColor, UIColor.ypBlack.withAlphaComponent(0.2).cgColor]
        let view = UIView()
        view.backgroundColor = .red
        view.layer.insertSublayer(gradient, at: 0)
        return view
    }()
    
    private lazy var cellContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.addSubViews(cellImageView, likeButton, gradientView, dateLabel)
        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func configure(image: UIImage, date: String, likeImageButton: UIImage) {
        cellImageView.image = image
        dateLabel.text = date
        likeButton.setImage(likeImageButton, for: .normal)
    }
    
    private func configureUI() {
        backgroundColor = .ypBlack
        addSubViews(cellContainerView)
        
        gradientView.layer.borderColor = UIColor.red.cgColor
        gradientView.layer.borderWidth = 1
    
        NSLayoutConstraint.activate([
            cellContainerView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            cellContainerView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            cellContainerView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            cellContainerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            
            cellImageView.topAnchor.constraint(equalTo: cellContainerView.topAnchor),
            cellImageView.leadingAnchor.constraint(equalTo: cellContainerView.leadingAnchor),
            cellImageView.trailingAnchor.constraint(equalTo: cellContainerView.trailingAnchor),
            cellImageView.bottomAnchor.constraint(equalTo: cellContainerView.bottomAnchor),
            
            likeButton.topAnchor.constraint(equalTo: cellContainerView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: cellContainerView.trailingAnchor),
            
            dateLabel.leadingAnchor.constraint(equalTo: cellContainerView.leadingAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: cellContainerView.bottomAnchor, constant: -8),
            
            gradientView.leadingAnchor.constraint(equalTo: cellContainerView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: cellContainerView.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: cellContainerView.bottomAnchor)
        ])
    }
    
    @objc private func likeButtonTap(_ sender: Any) {
    }
}

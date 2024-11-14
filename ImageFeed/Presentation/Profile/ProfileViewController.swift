//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Alexey Kremnev on 11/2/24.
//

import UIKit

final class ProfileViewController: UIViewController {

    private let nameText = "Екатерина Новикова"
    private let usernameText = "@ekaterina_nov"
    private let descriptionText = "Hello, world!"
    
    private var favoriteImageNames: [String] = [] {
        didSet {
            favoritesCountLabel.text = "\(favoriteImageNames.count)"
        }
    }
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Avatar"))
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(named: "Exit") ?? UIImage(),
            target: self,
            action: #selector(logoutButtonDidTap)
        )
        button.tintColor = .ypRed
        return button
    }()
    
    private lazy var nameLabel: UILabel = UILabel(
        text: self.nameText,
        font: .systemFont(ofSize: 23, weight: .bold),
        textColor: .ypWhite)
    
    private lazy var usernameLabel: UILabel = UILabel(
        text: self.usernameText,
        font: .systemFont(ofSize: 13, weight: .regular),
        textColor: .ypGray)
    
    private lazy var descriptionLabel: UILabel = {
        let textView = UILabel(
            text: descriptionText,
            font: .systemFont(ofSize: 13, weight: .regular),
            textColor: .ypWhite)
    
        textView.numberOfLines = 2
        return textView
    }()
    
    private lazy var favoritesLabel: UILabel = UILabel(
        text: "Избранное",
        font: .systemFont(ofSize: 23, weight: .bold),
        textColor: .ypWhite)
  
    
    private lazy var favoritesCountLabel: UILabel = {
        let label = UILabel(
            text: "\(favoriteImageNames.count)",
            font: .systemFont(ofSize: 13, weight: .regular),
            textColor: .ypWhite)
        
        label.textAlignment = .center
        label.backgroundColor = .ypBlue
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        return label
    }()
    
    private lazy var emptyImageView: UIImageView = {
        UIImageView(image: UIImage(named: "No Photo") ?? UIImage())
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .ypBlack
    
        view.addSubViews(profileImageView, nameLabel, logoutButton, usernameLabel, descriptionLabel, favoritesLabel,
            favoritesCountLabel, emptyImageView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            logoutButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            
            usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            usernameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: logoutButton.trailingAnchor),
            
            favoritesCountLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 40),
            favoritesCountLabel.heightAnchor.constraint(equalToConstant: 22),
            
            favoritesLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
            favoritesLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            
            favoritesCountLabel.centerYAnchor.constraint(equalTo: favoritesLabel.centerYAnchor),
            favoritesCountLabel.leadingAnchor.constraint(equalTo: favoritesLabel.trailingAnchor, constant: 8),
            
            emptyImageView.widthAnchor.constraint(equalToConstant: 115),
            emptyImageView.heightAnchor.constraint(equalTo: emptyImageView.widthAnchor),
            emptyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyImageView.topAnchor.constraint(equalTo: favoritesLabel.bottomAnchor, constant: 110),
        ])
    }
    
    @objc private func logoutButtonDidTap(_ sender: Any) {
        print("logging out")
    }
}


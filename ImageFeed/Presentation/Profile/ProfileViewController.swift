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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .ypBlack
    
        view.addSubViews(profileImageView, nameLabel, logoutButton, usernameLabel, descriptionLabel)
        
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
        ])
    }
    
    @objc private func logoutButtonDidTap(_ sender: Any) {
        print("logging out")
    }
}


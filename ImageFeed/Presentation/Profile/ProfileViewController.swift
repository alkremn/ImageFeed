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
    
    private var favoriteImageNames: [String] = []
    
    private lazy var profileImageView: UIImageView = {
        guard let image = UIImage(named: "Avatar") else { return UIImageView() }
        let imageView = UIImageView(image: image)
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
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = self.nameText
        label.font = .systemFont(ofSize: 23, weight: .bold)
        return label
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.text = self.usernameText
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .ypGray
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let textView = UILabel()
        textView.text = descriptionText
        textView.numberOfLines = 2
        textView.font = .systemFont(ofSize: 13, weight: .regular)
        textView.textColor = .white
        return textView
    }()
    
    private lazy var favoritesCountLabel: UILabel = {
        let label = UILabel()
        label.text = "\(favoriteImageNames.count)"
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .ypWhite
        label.textAlignment = .center
        label.backgroundColor = .ypBlue
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        return label
    }()
    
    private lazy var favoritesHStack: UIStackView = {
        let favoritesLabel = UILabel()
        favoritesLabel.text = "Избранное"
        favoritesLabel.font = .systemFont(ofSize: 23, weight: .bold)
        favoritesLabel.textColor = .ypWhite
        
        let stackView = UIStackView(arrangedSubviews: [
            favoritesLabel,
            favoritesCountLabel
        ])
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
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
        emptyImageView.isHidden = !favoriteImageNames.isEmpty
        favoritesCountLabel.isHidden = favoriteImageNames.isEmpty
        
        [profileImageView, nameLabel, logoutButton, usernameLabel,
         descriptionLabel, favoritesHStack, emptyImageView].forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        })
        
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
            
            favoritesHStack.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
            favoritesHStack.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            
            emptyImageView.widthAnchor.constraint(equalToConstant: 115),
            emptyImageView.heightAnchor.constraint(equalTo: emptyImageView.widthAnchor),
            emptyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyImageView.topAnchor.constraint(equalTo: favoritesHStack.bottomAnchor, constant: 110),
        ])
    }
    
    @objc func logoutButtonDidTap(_ sender: Any) {
        print("logging out")
    }
}


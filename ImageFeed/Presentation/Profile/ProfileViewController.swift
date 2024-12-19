//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Alexey Kremnev on 11/2/24.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(named: "exit") ?? UIImage(),
            target: self,
            action: #selector(logoutButtonDidTap)
        )
        button.tintColor = .ypRed
        return button
    }()
    
    private lazy var nameLabel: UILabel = UILabel(
        font: .systemFont(ofSize: 23, weight: .bold),
        textColor: .ypWhite)
    
    private lazy var loginNameLabel: UILabel = UILabel(
        font: .systemFont(ofSize: 13, weight: .regular),
        textColor: .ypGray)
    
    private lazy var descriptionLabel: UILabel = {
        let textView = UILabel(
            font: .systemFont(ofSize: 13, weight: .regular),
            textColor: .ypWhite)
    
        textView.numberOfLines = 2
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self else { return }
                self.updateAvatar()
            }
        
        updateAvatar()
        
        if let profile = ProfileService.shared.profile {
            updateProfileDetails(with: profile)
        }
    }
    
    private func updateProfileDetails(with profile: Profile) {
        nameLabel.text = profile.name
        loginNameLabel.text = "@\(profile.loginName)"
        descriptionLabel.text = profile.bio
    }
    
    private func updateAvatar() {
        guard
            let profileImageURLString = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURLString)
        else { return }
        
        profileImageView.kf.setImage(with: url)
    }
    
    private func configureUI() {
        view.backgroundColor = .ypBlack
        view.addSubViews(profileImageView, nameLabel, logoutButton, loginNameLabel, descriptionLabel)
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
            
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: loginNameLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: logoutButton.trailingAnchor),
        ])
    }
    
    @objc private func logoutButtonDidTap(_ sender: Any) {
        OAuth2TokenStorage.shared.removeToken()
        navigationController?.popToRootViewController(animated: true)
    }
}


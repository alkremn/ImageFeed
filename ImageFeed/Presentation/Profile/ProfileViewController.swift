//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Alexey Kremnev on 11/2/24.
//

import UIKit
import Kingfisher

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func setProfileImage(with url: URL)
    func updateProfileDetails(with profile: Profile)
    func show(alert: AlertModel)
    func didAlertDismiss()
    func didRedirect(to controller: UIViewController)
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    
    var presenter: ProfilePresenterProtocol?
    
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
        button.accessibilityIdentifier = "logout_button"
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
        presenter?.viewDidLoad()
    }
    
    func updateProfileDetails(with profile: Profile) {
        nameLabel.text = profile.name
        loginNameLabel.text = "@\(profile.loginName)"
        descriptionLabel.text = profile.bio
    }
    
    func setProfileImage(with url: URL) {
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
    
    
    func didRedirect(to controller: UIViewController) {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("[logoutButtonDidTap]: ConfigurationError - Invalid window configuration")
            return
        }
        window.rootViewController = controller
    }
    
    func show(alert: AlertModel) {
        AlertPresenter.show(self, alertModal: alert)
    }
    
    func didAlertDismiss() {
        dismiss(animated: true)
    }
    
    @objc private func logoutButtonDidTap(_ sender: Any) {
        presenter?.didLogoutRequest()
    }
}

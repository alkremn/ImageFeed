//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Alexey Kremnev on 11/23/24.
//

import UIKit

final class SplashViewController: UIViewController {
    
    private lazy var logoImageView: UIImageView = {
        UIImageView(image: UIImage(named: "splash_screen_logo"))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        OAuth2TokenStorage.shared.token != nil
        ? fetchProfile(OAuth2TokenStorage.shared.token!)
        : presentAuthController()
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("[switchToTabBarController]: ConfigurationError - Invalid window configuration")
            return
        }
        
        window.rootViewController = createTabBarController()
    }
    
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        ProfileService.shared.fetchProfile(token: token) { [weak self] result in
            guard let self else { return }
            UIBlockingProgressHUD.dismiss()
            
            switch result {
            case .success(let profile):
                self.fetchProfileImage(token: token, username: profile.username)
                self.switchToTabBarController()
            case .failure(let error):
                print("[fetchProfile]: NetworkError - Failed to get profile with error \(error)")
                self.presentAuthController()
            }
        }
    }
    
    private func presentAuthController() {
        let authVC = AuthViewController()
        authVC.delegate = self
        let navVC = UINavigationController(rootViewController: authVC)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
    
    private func fetchProfileImage(token: String, username: String) {
        ProfileImageService.shared.fetchProfileImageURL(
            token: token,
            username: username) { result in
                switch result {
                case .success(_):
                    break
                case .failure(let error):
                    print("[fetchProfileImage]: NetworkError - Failed to get profile image url with error \(error)")
                }
            }
    }
    
    private func createTabBarController() -> UITabBarController {
        let imagesListVC = ImagesListViewController()
        let profileVC = ProfileViewController()
        
        imagesListVC.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tab_editorial_active"),
            selectedImage: nil
        )
        
        profileVC.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil
        )
        
        let tabBarController =  UITabBarController()
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .ypBlack
        tabBarController.tabBar.standardAppearance = appearance
        tabBarController.viewControllers = [imagesListVC, profileVC]
        
        return tabBarController
    }
    
    private func configureUI() {
        view.addSubViews(logoImageView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 228)
        ])
    }
}

//MARK: - AuthViewControllerDelegate

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        
        guard let token = OAuth2TokenStorage.shared.token else { return }
        fetchProfile(token)
    }
}

//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Alexey Kremnev on 1/22/25.
//

import UIKit

protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func didTapLogoutButton()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    
    private let profileService: ProfileServiceProtocol
    private let profileImageService: ProfileImageServiceProtocol
    private let profileLogoutService: ProfileLogoutServiceProtocol
    private var profileImageServiceObserver: NSObjectProtocol?

    init(
        profileService: ProfileServiceProtocol,
        profileImageService: ProfileImageServiceProtocol,
        profileLogoutService: ProfileLogoutServiceProtocol
    ) {
        self.profileService = profileService
        self.profileImageService = profileImageService
        self.profileLogoutService = profileLogoutService
    }
    
    func viewDidLoad() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self else { return }
                self.updateProfileImage()
            }
        
        updateProfileDetails()
        updateProfileImage()
    }
    
    func updateProfileImage() {
        guard
            let profileImageURLString = profileImageService.avatarURL,
            let url = URL(string: profileImageURLString)
        else { return }
        
        view?.setProfileImage(with: url)
    }
    
    func updateProfileDetails() {
        if let profile = profileService.profile {
            view?.updateProfileDetails(with: profile)
        }
    }
    
    func didTapLogoutButton() {
        let yesAction = AlertAction(buttonText: "Да", isPreferred: true) { [weak self] in
            self?.didConfirmLogout()
        }
        
        let noAction = AlertAction(buttonText: "Нет") { [weak self] in
            self?.view?.dismissAlert()
        }
        
        let alertModel = AlertModel(
            title: "Пока, пока!",
            message: "Уверены что хотите выйти?",
            actions: [
                yesAction,
                noAction
            ])
        
        view?.show(alert: alertModel)
    }
    
    func didConfirmLogout() {
        profileLogoutService.logout()
        view?.redirect(to: SplashViewController())
    }
}

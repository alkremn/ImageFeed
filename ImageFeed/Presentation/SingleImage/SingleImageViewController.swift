//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Alexey Kremnev on 11/4/24.
//

import UIKit

final class SingleImageViewController: UIViewController {
    
    private lazy var imageView: UIImageView = { UIImageView() }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        scrollView.addSubViews(imageView)
        return scrollView
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "nav_back"), for: .normal)
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        button.accessibilityIdentifier = "nav_back_button_white"
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "share"), for: .normal)
        button.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configure(imageUrl: URL) {
        UIBlockingProgressHUD.show()
        setImage(with: imageUrl)
    }
    
    private func setImage(with imageUrl: URL) {
        imageView.kf.setImage(with: imageUrl) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self else { return }
            
            switch result {
            case .success(let imageResult):
                self.setImageInitialScale(image: imageResult.image)
            case .failure(let error):
                print("SingleImageViewController.configure - ImageLoadError: Unable to download image with error \(error)")
                showFailureAlert(imageUrl)
            }
        }
    }
    
    @objc private func didTapBackButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @objc private func didTapShareButton(_ sender: Any) {
        guard let image = imageView.image else { return }
        
        let activityVC = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        
        if #available(iOS 13.0, *) {
            activityVC.excludedActivityTypes = [.addToReadingList, .openInIBooks, .markupAsPDF]
        }
        
        present(activityVC, animated: true, completion: nil)
    }
    
    private func setImageInitialScale(image: UIImage) {
        view.layoutIfNeeded()
        
        let visibleRectSize = scrollView.bounds.size
        let hScale = visibleRectSize.width / image.size.width
        let vScale = visibleRectSize.height / image.size.height
        let theoreticalScale = min(hScale, vScale)
        let scale = min(scrollView.maximumZoomScale, max(scrollView.minimumZoomScale, theoreticalScale))
        
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        
        recenterImageInScrollView(image: image)
    }
    
    private func recenterImageInScrollView(image: UIImage) {
        let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
        let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
        
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX)
    }
    
    private func showFailureAlert(_ imageUrl: URL) {
        let alertModel = AlertModel(
            title: "Что-то пошло не так. Попробовать ещё раз?",
            message: nil,
            actions: [
                AlertAction(buttonText: "Не надо") { [weak self] in
                    self?.dismiss(animated: true)
                },
                AlertAction(
                    buttonText: "Повторить",
                    isPreferred: true) { [weak self] in
                        self?.setImage(with: imageUrl)
                    }
            ])
        
        AlertPresenter.show(self, alertModal: alertModel)
    }
    
    //MARK: - Configure Layout
    
    private func configureUI() {
        view.backgroundColor = .ypBlack
        view.addSubViews(scrollView, backButton, shareButton)
        addConstraints()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            backButton.widthAnchor.constraint(equalToConstant: 48),
            backButton.heightAnchor.constraint(equalToConstant: 48),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            
            shareButton.widthAnchor.constraint(equalToConstant: 50),
            shareButton.heightAnchor.constraint(equalToConstant: 50),
            shareButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            shareButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 17)
        ])
    }
}

//MARK: - UIScrollViewDelegate

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        guard let image = imageView.image else { return }
        recenterImageInScrollView(image: image)
    }
}

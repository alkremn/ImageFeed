//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Alexey Kremnev on 11/4/24.
//

import UIKit

final class SingleImageViewController: UIViewController {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageView: UIImageView!
    
    var image: UIImage? {
        didSet {
            guard isViewLoaded, let image = image else { return }
            
            imageView.image = image
            imageView.frame.size = image.size
            setImageInitialScale(image: image)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    @IBAction private func didTapBackButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction private func didTapShareButton(_ sender: Any) {
        guard let image = image else { return }

        let activityVC = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        
        if #available(iOS 13.0, *) {
                activityVC.excludedActivityTypes = [.addToReadingList, .openInIBooks, .markupAsPDF]
        }
        
        present(activityVC, animated: true, completion: nil)
    }
    
    private func configureUI() {
        scrollView.delegate = self
    
        if let image = image {
            imageView.image = image
            imageView.frame.size = image.size
            setImageInitialScale(image: image)
        }
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
}


extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        guard let image = image else { return }
        recenterImageInScrollView(image: image)
    }
}

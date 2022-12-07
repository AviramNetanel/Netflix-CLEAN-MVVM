//
//  OpaqueView.swift
//  netflix
//
//  Created by Zach Bazov on 20/09/2022.
//

import UIKit

final class OpaqueView: UIView {
    fileprivate var imageView: UIImageView!
    fileprivate var blurView: UIVisualEffectView!
    var viewModel: OpaqueViewViewModel!
    
    deinit {
        imageView = nil
        blurView = nil
        viewModel = nil
    }
    
    fileprivate func viewDidLoad() {
        imageView?.removeFromSuperview()
        blurView?.removeFromSuperview()
        
        imageView = .init(frame: UIScreen.main.bounds)
        imageView.contentMode = .scaleAspectFill
        
        let blurEffect = UIBlurEffect(style: .dark)
        blurView = .init(effect: blurEffect)
        blurView.frame = imageView.bounds
        
        insertSubview(imageView, at: 0)
        insertSubview(blurView, at: 1)
        
        AsyncImageFetcher.shared.load(
            url: viewModel.imageURL,
            identifier: viewModel.identifier) { [weak self] image in
                DispatchQueue.main.async { self?.imageView.image = image }
            }
    }
    
    func viewModelDidUpdate(with media: Media) {
        guard let presentedDisplayMedia = media as Media? else { return }
        self.viewModel = .init(with: presentedDisplayMedia)
        viewDidLoad()
    }
}

//
//  DefaultOpaqueView.swift
//  netflix
//
//  Created by Zach Bazov on 20/09/2022.
//

import UIKit

// MARK: - OpaqueViewInput protocol

private protocol OpaqueViewInput {
    func configure(with viewModel: DefaultOpaqueViewViewModel)
}

// MARK: - OpaqueViewOutput protocol

private protocol OpaqueViewOutput {
    var imageView: UIImageView! { get }
    var blurView: UIVisualEffectView! { get }
}

// MARK: - OpaqueView protocol

private protocol OpaqueView: OpaqueViewInput, OpaqueViewOutput {}

// MARK: - DefaultOpaqueView class

final class DefaultOpaqueView: UIView, OpaqueView, ViewInstantiable {
    
    fileprivate var imageView: UIImageView!
    fileprivate var blurView: UIVisualEffectView!
    
    private var viewModel: DefaultOpaqueViewViewModel!
    
    deinit {
        imageView = nil
        blurView = nil
        viewModel = nil
    }
    
    @discardableResult
    static func createViewModel(on view: DefaultOpaqueView,
                                with viewModel: DefaultHomeViewModel) -> DefaultOpaqueViewViewModel? {
        guard let presentedDisplayMedia = viewModel.presentedDisplayMedia.value as Media? else { return nil }
        view.viewModel = DefaultOpaqueViewViewModel(with: presentedDisplayMedia)
        view.configure(with: view.viewModel)
        return view.viewModel
    }
    
    fileprivate func configure(with viewModel: DefaultOpaqueViewViewModel) {
        imageView?.removeFromSuperview()
        blurView?.removeFromSuperview()
        
        imageView = .init(frame: UIScreen.main.bounds)
        imageView.contentMode = .scaleAspectFill
        
        let blurEffect = UIBlurEffect(style: .dark)
        blurView = .init(effect: blurEffect)
        blurView.frame = imageView.bounds
        
        insertSubview(imageView, at: 0)
        insertSubview(blurView, at: 1)
        
        AsyncImageFetcher.shared.load(url: viewModel.imageURL,
                                      identifier: viewModel.identifier) { [weak self] image in
            DispatchQueue.main.async { self?.imageView.image = image }
        }
    }
}

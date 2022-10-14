//
//  OpaqueView.swift
//  netflix
//
//  Created by Zach Bazov on 20/09/2022.
//

import UIKit

// MARK: - ViewInput protocol

private protocol ViewInput {
    func viewDidLoad(with viewModel: OpaqueViewViewModel)
}

// MARK: - ViewOutput protocol

private protocol ViewOutput {
    var imageView: UIImageView! { get }
    var blurView: UIVisualEffectView! { get }
    var viewModel: OpaqueViewViewModel! { get }
}

// MARK: - View typealias

private typealias View = ViewInput & ViewOutput

// MARK: - OpaqueView class

final class OpaqueView: UIView, View {
    
    fileprivate var imageView: UIImageView!
    fileprivate var blurView: UIVisualEffectView!
    
    fileprivate var viewModel: OpaqueViewViewModel!
    
    deinit {
        imageView = nil
        blurView = nil
        viewModel = nil
    }
    
    @discardableResult
    static func createViewModel(on view: OpaqueView,
                                with viewModel: HomeViewModel) -> OpaqueViewViewModel? {
        guard let presentedDisplayMedia = viewModel.presentedDisplayMedia.value as Media? else { return nil }
        view.viewModel = .init(with: presentedDisplayMedia)
        view.viewDidLoad(with: view.viewModel)
        return view.viewModel
    }
    
    fileprivate func viewDidLoad(with viewModel: OpaqueViewViewModel) {
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
}
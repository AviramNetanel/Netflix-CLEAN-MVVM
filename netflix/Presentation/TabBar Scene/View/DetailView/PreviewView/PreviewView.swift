//
//  PreviewView.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit

// MARK: - ViewInput protocol

private protocol ViewInput {
    func viewDidConfigure(with viewModel: PreviewViewViewModel)
}

// MARK: - ViewOutput protocol

private protocol ViewOutput {}

// MARK: - View typelias

private typealias View = ViewInput & ViewOutput

// MARK: - PreviewView class

final class PreviewView: UIView {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: bounds)
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        return imageView
    }()
    
    @discardableResult
    static func create(on parent: UIView,
                       with viewModel: DetailViewModel) -> PreviewView {
        let view = PreviewView(frame: .zero)
        parent.addSubview(view)
        let previewViewViewModel = PreviewViewViewModel(with: viewModel.media)
        view.viewDidConfigure(with: previewViewViewModel)
        let mediaPlayerView = MediaPlayerView.create(on: view, with: viewModel)
        mediaPlayerView.prepareToPlay = { isPlaying in
            isPlaying ? view.imageView.isHidden(true) : view.imageView.isHidden(false)
        }
        mediaPlayerView.replace(item: mediaPlayerView.viewModel.item)
        mediaPlayerView.play()
        parent.addSubview(mediaPlayerView)
        mediaPlayerView.translatesAutoresizingMaskIntoConstraints = false
        mediaPlayerView.constraintToSuperview(parent)
        return view
    }
    
    fileprivate func viewDidConfigure(with viewModel: PreviewViewViewModel) {
        AsyncImageFetcher.shared.load(
            url: viewModel.url,
            identifier: viewModel.identifier) { [weak self] image in
                DispatchQueue.main.async { self?.imageView.image = image }
            }
    }
}

//
//  DetailPreviewView.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit

// MARK: - DetailPreviewView class

final class DetailPreviewView: UIView {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: bounds)
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        return imageView
    }()
    
    static func create(on parent: UIView,
                       with viewModel: DetailViewModel) -> DetailPreviewView {
        let view = DetailPreviewView(frame: parent.bounds)
        let previewViewViewModel = DetailPreviewViewViewModel(with: viewModel.media)
        view.configure(with: previewViewViewModel)
        let mediaPlayerView = MediaPlayerView.create(on: view,
                                                     with: viewModel)
        mediaPlayerView.prepareToPlay = { isPlaying in
            isPlaying ? view.imageView.isHidden(true) : view.imageView.isHidden(false)
        }
        mediaPlayerView.replace(item: mediaPlayerView.viewModel.item)
        mediaPlayerView.play()
        parent.addSubview(mediaPlayerView)
        return view
    }
    
    private func configure(with viewModel: DetailPreviewViewViewModel) {
        AsyncImageFetcher.shared.load(url: viewModel.url,
                                      identifier: viewModel.identifier) { image in
            DispatchQueue.main.async { [weak self] in self?.imageView.image = image }
        }
    }
}

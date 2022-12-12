//
//  PreviewView.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit

final class PreviewView: UIView {
    private var viewModel: PreviewViewViewModel!
    private(set) var mediaPlayerView: MediaPlayerView!
    private(set) lazy var imageView = createImageView()
    
    init(on parent: UIView, with viewModel: DetailViewModel) {
        self.viewModel = .init(with: viewModel.media)
        super.init(frame: .zero)
        parent.addSubview(self)
        self.constraintToSuperview(parent)
        self.viewDidConfigure()
        self.mediaPlayerView = createMediaPlayer(on: parent, view: self, with: viewModel)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    deinit {
        mediaPlayerView = nil
        viewModel = nil
        mediaPlayerView = nil
    }
    
    private func createMediaPlayer(on parent: UIView,
                                   view: PreviewView,
                                   with viewModel: DetailViewModel) -> MediaPlayerView {
        let mediaPlayerView = MediaPlayerView(on: view, with: viewModel)
        
        mediaPlayerView.prepareToPlay = { [weak self] isPlaying in
            isPlaying ? self?.imageView.isHidden(true) : self?.imageView.isHidden(false)
        }
        
        mediaPlayerView.delegate?.player(mediaPlayerView.mediaPlayer,
                                         willReplaceItem: mediaPlayerView.viewModel.item)
        mediaPlayerView.delegate?.playerDidPlay(mediaPlayerView.mediaPlayer)
        
        parent.addSubview(mediaPlayerView)
        mediaPlayerView.constraintToSuperview(parent)
        
        return mediaPlayerView
    }
    
    private func createImageView() -> UIImageView {
        let imageView = UIImageView(frame: bounds)
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        return imageView
    }
    
    private func viewDidConfigure() {
        AsyncImageFetcher.shared.load(
            url: viewModel.url,
            identifier: viewModel.identifier) { [weak self] image in
                asynchrony { self?.imageView.image = image }
            }
    }
}

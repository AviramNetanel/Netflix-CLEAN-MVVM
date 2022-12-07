//
//  PreviewView.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit

final class PreviewView: UIView {
    fileprivate lazy var imageView = createImageView()
    var viewModel: PreviewViewViewModel!
    
    init(on parent: UIView, with viewModel: DetailViewModel) {
        self.viewModel = .init(with: viewModel.media)
        super.init(frame: .zero)
        parent.addSubview(self)
        self.constraintToSuperview(parent)
        self.createMediaPlayer(on: parent, view: self, with: viewModel)
        self.viewDidConfigure()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func createMediaPlayer(on parent: UIView,
                                   view: PreviewView,
                                   with viewModel: DetailViewModel) {
        let mediaPlayerView = MediaPlayerView.create(on: view, with: viewModel)
        mediaPlayerView.prepareToPlay = { isPlaying in
            isPlaying ? view.imageView.isHidden(true) : view.imageView.isHidden(false)
        }
        mediaPlayerView.delegate?.player(mediaPlayerView.mediaPlayer,
                                         willReplaceItem: mediaPlayerView.viewModel.item)
        mediaPlayerView.delegate?.playerDidPlay(mediaPlayerView.mediaPlayer)
        parent.addSubview(mediaPlayerView)
        mediaPlayerView.constraintToSuperview(parent)
    }
    
    private func createImageView() -> UIImageView {
        let imageView = UIImageView(frame: bounds)
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        return imageView
    }
    
    fileprivate func viewDidConfigure() {
        AsyncImageFetcher.shared.load(
            url: viewModel.url,
            identifier: viewModel.identifier) { [weak self] image in
                DispatchQueue.main.async { self?.imageView.image = image }
            }
    }
}

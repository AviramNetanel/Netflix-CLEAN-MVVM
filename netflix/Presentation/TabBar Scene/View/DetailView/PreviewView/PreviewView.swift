//
//  PreviewView.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit

// MARK: - ViewInput protocol

private protocol ViewInput {
    func dataDidLoad(with viewModel: PreviewViewViewModel)
    func viewDidLoad()
}

// MARK: - ViewOutput protocol

private protocol ViewOutput {
    var imageView: UIImageView { get }
    var viewModel: PreviewViewViewModel! { get }
}

// MARK: - View typelias

private typealias View = ViewInput & ViewOutput

// MARK: - PreviewView class

final class PreviewView: UIView, View {
    
    fileprivate lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: bounds)
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        return imageView
    }()
    
    fileprivate var viewModel: PreviewViewViewModel!
    
    @discardableResult
    static func create(on parent: UIView,
                       with viewModel: DetailViewModel) -> PreviewView {
        let view = PreviewView(frame: .zero)
        parent.addSubview(view)
        view.constraintToSuperview(parent)
        createViewModel(on: view, with: viewModel)
        createMediaPlayer(on: parent, view: view, with: viewModel)
        view.viewDidLoad()
        return view
    }
    
    @discardableResult
    private static func createViewModel(on view: PreviewView,
                                        with viewModel: DetailViewModel) -> PreviewViewViewModel {
        view.viewModel = .init(with: viewModel.media)
        return view.viewModel
    }
    
    @discardableResult
    private static func createMediaPlayer(on parent: UIView,
                                          view: PreviewView,
                                          with viewModel: DetailViewModel) -> MediaPlayerView {
        let mediaPlayerView = MediaPlayerView.create(on: view, with: viewModel)
        mediaPlayerView.prepareToPlay = { isPlaying in
            isPlaying ? view.imageView.isHidden(true) : view.imageView.isHidden(false)
        }
        mediaPlayerView.delegate?.player(mediaPlayerView.mediaPlayer,
                                         willReplaceItem: mediaPlayerView.viewModel.item)
        mediaPlayerView.delegate?.playerDidPlay(mediaPlayerView.mediaPlayer)
        parent.addSubview(mediaPlayerView)
        mediaPlayerView.constraintToSuperview(parent)
        return mediaPlayerView
    }
    
    fileprivate func dataDidLoad(with viewModel: PreviewViewViewModel) {
        AsyncImageFetcher.shared.load(
            url: viewModel.url,
            identifier: viewModel.identifier) { [weak self] image in
                DispatchQueue.main.async { self?.imageView.image = image }
            }
    }
    
    fileprivate func viewDidLoad() { dataDidLoad(with: viewModel) }
}

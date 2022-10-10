//
//  MediaPlayerView.swift
//  netflix
//
//  Created by Zach Bazov on 04/10/2022.
//

import AVKit

// MARK: - ViewInput protocol

private protocol ViewInput {
    func configure()
    func verifyUrl(url: URL) -> Bool
    func recognizer(on parent: UIView)
    func stop()
    func replace(item: MediaPlayerViewItem?)
    func play()
}

// MARK: - ViewOutput protocol

private protocol ViewOutput {
    var mediaPlayerLayer: MediaPlayerLayer! { get }
    var prepareToPlay: ((Bool) -> Void)? { get }
}

// MARK: - View typealias

private typealias View = ViewInput & ViewOutput

// MARK: - MediaPlayerView class

final class MediaPlayerView: UIView, View {
    
    fileprivate(set) var mediaPlayerLayer: MediaPlayerLayer!
    private var mediaPlayerOverlayView: MediaPlayerOverlayView!
    private(set) var viewModel: MediaPlayerViewViewModel!
    
    var prepareToPlay: ((Bool) -> Void)?
    
    static func create(on parent: UIView,
                       with viewModel: DetailViewModel) -> MediaPlayerView {
        let view = MediaPlayerView(frame: .zero)
        view.viewModel = .init(with: viewModel)
        view.mediaPlayerLayer = .init(frame: .zero)
        view.addSubview(view.mediaPlayerLayer)
        view.configure()
        view.mediaPlayerOverlayView = MediaPlayerOverlayView.create(on: view,
                                                                    mediaPlayerView: view,
                                                                    with: view.viewModel)
        view.addSubview(view.mediaPlayerOverlayView)
        view.recognizer(on: view)
        view.mediaPlayerOverlayView.translatesAutoresizingMaskIntoConstraints = false
        view.mediaPlayerLayer.translatesAutoresizingMaskIntoConstraints = false
        view.mediaPlayerLayer.constraintToSuperview(view)
        view.mediaPlayerOverlayView.constraintToSuperview(view)
        return view
    }
    
    private func constraint(view: UIView, to parent: UIView) {
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: parent.topAnchor),
            view.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: parent.bottomAnchor)
        ])
    }
    
    deinit {
        print("deinitMediaPlayerView")
        mediaPlayerLayer = nil
        mediaPlayerOverlayView = nil
        viewModel = nil
        prepareToPlay = nil
    }
    
    fileprivate func configure() {
        mediaPlayerLayer.player = AVPlayer()
        mediaPlayerLayer.playerLayer.frame = mediaPlayerLayer.bounds
        mediaPlayerLayer.playerLayer.videoGravity = .resizeAspectFill
    }
    
    fileprivate func verifyUrl(url: URL) -> Bool { UIApplication.shared.canOpenURL(url) }
    
    fileprivate func recognizer(on parent: UIView) {
        let tapRecognizer = UITapGestureRecognizer(target: mediaPlayerOverlayView,
                                                   action: #selector(mediaPlayerOverlayView.didSelect))
        parent.addGestureRecognizer(tapRecognizer)
    }
    
    fileprivate func stop() {
        viewModel.isPlaying = false
        mediaPlayerLayer.player.replaceCurrentItem(with: nil)
    }
    
    func replace(item: MediaPlayerViewItem? = nil) {
        mediaPlayerLayer.player.replaceCurrentItem(with: item == nil ? viewModel.item : item!)
    }
    
    func play() {
        viewModel.isPlaying = true
        prepareToPlay?(viewModel.isPlaying)
        mediaPlayerLayer.player.play()
    }
}

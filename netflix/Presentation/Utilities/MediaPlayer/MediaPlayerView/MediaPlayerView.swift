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
    func replace(item: AVPlayerItem?)
    func play()
}

// MARK: - ViewOutput protocol

private protocol ViewOutput {
    var mediaPlayer: MediaPlayer! { get }
    
    var prepareToPlay: ((Bool) -> Void)? { get }
}

// MARK: - View typealias

private typealias View = ViewInput & ViewOutput

// MARK: - MediaPlayerView class

final class MediaPlayerView: UIView, View {
    
    fileprivate(set) var mediaPlayer: MediaPlayer!
    private var mediaPlayerOverlayView: MediaPlayerOverlayView!
    private(set) var viewModel: MediaPlayerViewViewModel!
    
    var prepareToPlay: ((Bool) -> Void)?
    
    static func create(on parent: UIView,
                       with viewModel: DetailViewModel) -> MediaPlayerView {
        let view = MediaPlayerView(frame: .zero)
        view.viewModel = .init(with: viewModel)
        view.mediaPlayer = .create(on: view)
        view.configure()
        view.mediaPlayerOverlayView = MediaPlayerOverlayView.create(on: view,
                                                                    mediaPlayerView: view,
                                                                    with: view.viewModel)
        view.addSubview(view.mediaPlayerOverlayView)
        view.recognizer(on: view)
        view.mediaPlayerOverlayView.translatesAutoresizingMaskIntoConstraints = false
        view.mediaPlayerOverlayView.constraintToSuperview(view)
        return view
    }
    
    deinit {
        removeObservers()
        mediaPlayer = nil
        mediaPlayerOverlayView = nil
        viewModel = nil
        prepareToPlay = nil
    }
    
    fileprivate func configure() {
        mediaPlayer.mediaPlayerLayer.playerLayer.frame = mediaPlayer.mediaPlayerLayer.bounds
        mediaPlayer.mediaPlayerLayer.playerLayer.videoGravity = .resizeAspectFill
    }
    
    fileprivate func verifyUrl(url: URL) -> Bool { UIApplication.shared.canOpenURL(url) }
    
    fileprivate func recognizer(on parent: UIView) {
        let tapRecognizer = UITapGestureRecognizer(target: mediaPlayerOverlayView,
                                                   action: #selector(mediaPlayerOverlayView.didSelect))
        parent.addGestureRecognizer(tapRecognizer)
    }
    
    fileprivate func stop() {
        viewModel.isPlaying = false
        mediaPlayer.player.replaceCurrentItem(with: nil)
    }
    
    func replace(item: AVPlayerItem? = nil) {
        mediaPlayer.player.replaceCurrentItem(with: item == nil ? viewModel.item : item!)
    }
    
    func play() {
        viewModel.isPlaying = true
        prepareToPlay?(viewModel.isPlaying)
        mediaPlayer.player.play()
    }
    
    func removeObservers() {
        mediaPlayer?.player.removeTimeObserver(mediaPlayerOverlayView!.observers!.timeObserverToken!)
    }
}

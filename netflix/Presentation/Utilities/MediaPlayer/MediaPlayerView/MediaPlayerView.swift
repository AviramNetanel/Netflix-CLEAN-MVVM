//
//  MediaPlayerView.swift
//  netflix
//
//  Created by Zach Bazov on 04/10/2022.
//

import AVKit

// MARK: - ViewInput protocol

private protocol ViewInput {
    func viewDidLoad()
    func viewDidRegisterRecognizers(on parent: UIView)
    func verifyUrl(url: URL) -> Bool
    func stop()
    func replace(item: AVPlayerItem?)
    func play()
    var prepareToPlay: ((Bool) -> Void)? { get }
}

// MARK: - ViewOutput protocol

private protocol ViewOutput {
    var mediaPlayer: MediaPlayer! { get }
    var overlayView: MediaPlayerOverlayView! { get }
    var viewModel: MediaPlayerViewViewModel! { get }
}

// MARK: - View typealias

private typealias View = ViewInput & ViewOutput

// MARK: - MediaPlayerView class

final class MediaPlayerView: UIView, View {
    
    fileprivate(set) var mediaPlayer: MediaPlayer!
    fileprivate var overlayView: MediaPlayerOverlayView!
    fileprivate(set) var viewModel: MediaPlayerViewViewModel!
    
    var prepareToPlay: ((Bool) -> Void)?
    
    deinit {
        removeObservers()
        mediaPlayer = nil
        overlayView = nil
        viewModel = nil
        prepareToPlay = nil
    }
    
    static func create(on parent: UIView,
                       with viewModel: DetailViewModel) -> MediaPlayerView {
        let view = MediaPlayerView(frame: .zero)
        createViewModel(on: view, with: viewModel)
        createMediaPlayer(on: view)
        view.viewDidLoad()
        view.addSubview(createMediaPlayerOverlayView(on: view))
        view.viewDidRegisterRecognizers(on: view)
        view.overlayView.constraintToSuperview(view)
        return view
    }
    
    @discardableResult
    private static func createViewModel(on view: MediaPlayerView,
                                        with viewModel: DetailViewModel) -> MediaPlayerViewViewModel {
        view.viewModel = .init(with: viewModel)
        return view.viewModel
    }
    
    @discardableResult
    private static func createMediaPlayer(on view: MediaPlayerView) -> MediaPlayer {
        view.mediaPlayer = .create(on: view)
        return view.mediaPlayer
    }
    
    private static func createMediaPlayerOverlayView(on view: MediaPlayerView) -> MediaPlayerOverlayView {
        view.overlayView = .create(on: view)
        return view.overlayView
    }
    
    fileprivate func viewDidLoad() {
        mediaPlayer.mediaPlayerLayer.playerLayer.frame = mediaPlayer.mediaPlayerLayer.bounds
        mediaPlayer.mediaPlayerLayer.playerLayer.videoGravity = .resizeAspectFill
    }
    
    fileprivate func verifyUrl(url: URL) -> Bool { UIApplication.shared.canOpenURL(url) }
    
    fileprivate func viewDidRegisterRecognizers(on parent: UIView) {
        let tapRecognizer = UITapGestureRecognizer(target: overlayView,
                                                   action: #selector(overlayView.didSelect))
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
        mediaPlayer?.player.removeTimeObserver(overlayView!.observers.timeObserverToken!)
    }
}

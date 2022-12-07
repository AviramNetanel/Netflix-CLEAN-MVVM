//
//  MediaPlayerView.swift
//  netflix
//
//  Created by Zach Bazov on 04/10/2022.
//

import AVKit

final class MediaPlayerView: UIView {
    fileprivate(set) var mediaPlayer: MediaPlayer!
    fileprivate var overlayView: MediaPlayerOverlayView!
    var viewModel: MediaPlayerViewViewModel!
    
    var prepareToPlay: ((Bool) -> Void)?
    
    weak var delegate: MediaPlayerDelegate?
    
    deinit {
        removeObservers()
        mediaPlayer = nil
        overlayView = nil
        viewModel = nil
        prepareToPlay = nil
        delegate = nil
    }
    
    static func create(on parent: UIView,
                       with viewModel: DetailViewModel) -> MediaPlayerView {
        let view = MediaPlayerView(frame: .zero)
        view.delegate = view
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
    
    fileprivate func viewDidRegisterRecognizers(on parent: UIView) {
        let tapRecognizer = UITapGestureRecognizer(target: overlayView,
                                                   action: #selector(overlayView.didSelect))
        parent.addGestureRecognizer(tapRecognizer)
    }
    
    func removeObservers() {
        if let timeObserverToken = overlayView.configuration.observers.timeObserverToken {
            printIfDebug("Removed `MediaPlayerView` observers.")
            mediaPlayer?.player.removeTimeObserver(timeObserverToken)
        }
    }
}

extension MediaPlayerView: MediaPlayerDelegate {
    func playerDidPlay(_ mediaPlayer: MediaPlayer) {
        viewModel.isPlaying = true
        prepareToPlay?(viewModel.isPlaying)
        mediaPlayer.player.play()
    }
    
    func playerDidStop(_ mediaPlayer: MediaPlayer) {
        viewModel.isPlaying = false
        mediaPlayer.player.replaceCurrentItem(with: nil)
    }
    
    func player(_ mediaPlayer: MediaPlayer,
                willReplaceItem item: AVPlayerItem? = nil) {
        mediaPlayer.player.replaceCurrentItem(with: item == nil ? viewModel.item : item!)
    }
    
    func player(_ mediaPlayer: MediaPlayer,
                willVerifyUrl url: URL) -> Bool { UIApplication.shared.canOpenURL(url) }
}

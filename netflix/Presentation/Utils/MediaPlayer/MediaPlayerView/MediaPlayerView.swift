//
//  MediaPlayerView.swift
//  netflix
//
//  Created by Zach Bazov on 04/10/2022.
//

import AVKit

final class MediaPlayerView: UIView {
    var mediaPlayer: MediaPlayer!
    var overlayView: MediaPlayerOverlayView!
    var viewModel: MediaPlayerViewViewModel!
    
    var prepareToPlay: ((Bool) -> Void)?
    
    weak var delegate: MediaPlayerDelegate?
    
    init(on parent: UIView, with viewModel: DetailViewModel) {
        super.init(frame: parent.bounds)
        self.delegate = self
        self.viewModel = MediaPlayerViewViewModel(with: viewModel)
        self.mediaPlayer = .create(on: self)
        self.overlayView = .create(on: self)
        self.addSubview(self.overlayView)
        self.viewDidRegisterRecognizers(on: self)
        self.overlayView.constraintToSuperview(self)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    deinit {
        removeObservers()
        mediaPlayer = nil
        overlayView = nil
        viewModel = nil
        prepareToPlay = nil
        delegate = nil
    }
    
    private func viewDidLoad() {
        mediaPlayer.mediaPlayerLayer.playerLayer.frame = mediaPlayer.mediaPlayerLayer.bounds
        mediaPlayer.mediaPlayerLayer.playerLayer.videoGravity = .resizeAspectFill
    }
    
    private func viewDidRegisterRecognizers(on parent: UIView) {
        let tapRecognizer = UITapGestureRecognizer(target: overlayView,
                                                   action: #selector(overlayView.didSelect))
        parent.addGestureRecognizer(tapRecognizer)
    }
    
    func removeObservers() {
        if let timeObserverToken = overlayView?.configuration.observers.timeObserverToken {
            printIfDebug("Removed `MediaPlayerView` observers.")
            mediaPlayer?.player.removeTimeObserver(timeObserverToken)
        }
    }
    
    func stopPlayer() {
        guard let mediaPlayer = mediaPlayer else { return }
        playerDidStop(mediaPlayer)
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

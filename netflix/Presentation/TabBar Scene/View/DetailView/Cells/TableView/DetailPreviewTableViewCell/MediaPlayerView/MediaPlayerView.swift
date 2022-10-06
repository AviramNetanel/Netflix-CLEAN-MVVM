//
//  MediaPlayerView.swift
//  netflix
//
//  Created by Zach Bazov on 04/10/2022.
//

import AVKit

// MARK: - ConfigurationInput protocol

private protocol ConfigurationInput {
    func recognizerDidRegister()
}

// MARK: - ConfigurationOutput protocol

private protocol ConfigurationOutput {
    var tapRecognizer: UITapGestureRecognizer { get }
    var durationThreshold: CGFloat { get }
}

// MARK: - Configuration typealias

private typealias Configuration = ConfigurationInput & ConfigurationOutput

// MARK: - MediaPlayerViewConfiguration

struct MediaPlayerViewConfiguration: Configuration {
    
    let tapRecognizer: UITapGestureRecognizer
    let durationThreshold: CGFloat
    
    private weak var mediaPlayerView: MediaPlayerView?
    
    init(tapRecognizer: UITapGestureRecognizer,
         durationThreshold: CGFloat,
         with mediaPlayerView: MediaPlayerView) {
        self.tapRecognizer = tapRecognizer
        self.durationThreshold = durationThreshold
        self.mediaPlayerView = mediaPlayerView
    }
    
    func recognizerDidRegister() {
        mediaPlayerView?.addGestureRecognizer(tapRecognizer)
    }
}

// MARK: - ViewInput protocol

private protocol ViewInput {
    func configure()
    func verifyUrl(url: URL) -> Bool
    func replace(item: MediaPlayerViewItem?)
    func play()
    func stop()
}

// MARK: - ViewOutput protocol

private protocol ViewOutput {
    var playerView: AVPlayerView! { get }
    var prepareToPlay: ((Bool) -> Void)? { get }
}

// MARK: - View typealias

private typealias View = ViewInput & ViewOutput

// MARK: - MediaPlayerView class

final class MediaPlayerView: UIView, View {
    
    fileprivate var playerView: AVPlayerView!
    
    private var configuration: MediaPlayerViewConfiguration!
    
    private(set) var viewModel: MediaPlayerViewViewModel!
    
    var prepareToPlay: ((Bool) -> Void)?
    
    static func create(on parent: UIView,
                       with viewModel: DetailViewModel) -> MediaPlayerView {
        let view = MediaPlayerView(frame: parent.bounds)
        let tapRecognizer = UITapGestureRecognizer(target: view,
                                                   action: #selector(view.x))
        view.configuration = .init(tapRecognizer: tapRecognizer,
                                   durationThreshold: 3.0,
                                   with: view)
        view.viewModel = .init(with: viewModel)
        view.playerView = .init(frame: view.bounds)
        parent.addSubview(view.playerView)
        view.configure()
        return view
    }
    
    fileprivate func configure() {
        playerView.player = AVPlayer()
        playerView.playerLayer.frame = playerView.bounds
        playerView.playerLayer.videoGravity = .resizeAspectFill
    }
    
    fileprivate func verifyUrl(url: URL) -> Bool { UIApplication.shared.canOpenURL(url) }
    
    func replace(item: MediaPlayerViewItem? = nil) {
        playerView.player.replaceCurrentItem(with: item == nil ? viewModel.item : item!)
    }
    
    func play() {
        viewModel.isPlaying = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let self = self else { return }
            self.prepareToPlay?(self.viewModel.isPlaying)
            self.playerView.player.play()
        }
    }
    
    func stop() {
        viewModel.isPlaying = false
        playerView.player.replaceCurrentItem(with: nil)
    }
    
    @objc
    func x() {
        
    }
}

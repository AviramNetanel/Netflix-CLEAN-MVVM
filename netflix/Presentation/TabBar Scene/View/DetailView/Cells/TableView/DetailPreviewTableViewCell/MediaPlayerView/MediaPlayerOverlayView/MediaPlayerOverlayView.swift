//
//  MediaPlayerOverlayView.swift
//  netflix
//
//  Created by Zach Bazov on 06/10/2022.
//

import AVKit
import Combine

// MARK: - ObserverInput protocol

private protocol ObserverInput {}

// MARK: - ObserverOutput protocol

protocol ObserverOutput {
    var timeObserverToken: Any! { get set }
    var playerItemStatusObserver: NSKeyValueObservation! { get set }
    var playerItemFastForwardObserver: NSKeyValueObservation! { get set }
    var playerItemReverseObserver: NSKeyValueObservation! { get set }
    var playerItemFastReverseObserver: NSKeyValueObservation! { get set }
    var playerTimeControlStatusObserver: NSKeyValueObservation! { get set }
    var playerItemDidEndPlayingObserver: NSKeyValueObservation! { get set }
    var cancelBag: Set<AnyCancellable>! { get set }
}

// MARK: - Observer typealias

private typealias Observer = ObserverInput & ObserverOutput

// MARK: - MediaPlayerOverlayViewObservers

struct MediaPlayerOverlayViewObservers: Observer {
    var timeObserverToken: Any!
    var playerItemStatusObserver: NSKeyValueObservation!
    var playerItemFastForwardObserver: NSKeyValueObservation!
    var playerItemReverseObserver: NSKeyValueObservation!
    var playerItemFastReverseObserver: NSKeyValueObservation!
    var playerTimeControlStatusObserver: NSKeyValueObservation!
    var playerItemDidEndPlayingObserver: NSKeyValueObservation!
    var cancelBag: Set<AnyCancellable>!
}

// MARK: - ConfigurationInput protocol

private protocol ConfigurationInput {}

// MARK: - ConfigurationOutput protocol

private protocol ConfigurationOutput {
    var durationThreshold: CGFloat { get }
    var repeats: Bool { get }
}

// MARK: - Configuration typealias

private typealias Configuration = ConfigurationInput & ConfigurationOutput

// MARK: - MediaPlayerViewConfiguration

private struct MediaPlayerOverlayViewConfiguration: Configuration {
    let durationThreshold: CGFloat
    var repeats: Bool
}

// MARK: - ViewInput protocol

private protocol ViewInput {
    func viewWillAppear()
    func viewWillDisappear()
    func viewDidConfigure()
    func viewDidRegisterObservers()
//    func stateDidChange()
//    func didSelect()
}

// MARK: - ViewOutput protocol

private protocol ViewOutput {
    var observers: MediaPlayerOverlayViewObservers! { get }
}

// MARK: - View typealias

private typealias View = ViewInput & ViewOutput

// MARK: - MediaPlayerOverlayView class

final class MediaPlayerOverlayView: UIView, View, ViewInstantiable {
    
    private enum State: Int {
        case airPlay
        case rotate
        case backward
        case play
        case forward
        case mute
    }
    
    @IBOutlet private weak var airPlayButton: UIButton!
    @IBOutlet private weak var rotateButton: UIButton!
    @IBOutlet private(set) weak var backwardButton: UIButton!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var forwardButton: UIButton!
    @IBOutlet private weak var muteButton: UIButton!
    @IBOutlet private(set) weak var progressView: UIProgressView!
    @IBOutlet private(set) weak var trackingSlider: UISlider!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var startTimeLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var timeSeparatorLabel: UILabel!
    @IBOutlet private weak var gradientView: UIView!
    
    private var viewModel: MediaPlayerViewViewModel!
    private var configuration: MediaPlayerOverlayViewConfiguration!
    fileprivate var observers: MediaPlayerOverlayViewObservers!
    private var timer = ScheduledTimer()
    private weak var mediaPlayerView: MediaPlayerView!

    static func create(on parent: UIView,
                       mediaPlayerView: MediaPlayerView,
                       with viewModel: MediaPlayerViewViewModel) -> MediaPlayerOverlayView {
        let view = MediaPlayerOverlayView(frame: parent.bounds)
        view.nibDidLoad()
        view.viewModel = viewModel
        view.observers = .init()
        view.mediaPlayerView = mediaPlayerView
        view.configuration = .init(durationThreshold: 3.0, repeats: true)
        view.setupObservers()
        view.setupSubviews()
        return view
    }
    
    deinit {
        print("deinitMediaPlayerOverlayView")
        timer.invalidate()
        removeObservers()
        mediaPlayerView = nil
        configuration = nil
        observers = nil
        viewModel = nil
    }
    
    private func setupSubviews() {
        setupTargets(for: airPlayButton,
                     rotateButton,
                     backwardButton,
                     playButton,
                     forwardButton,
                     muteButton)
        
        viewDidConfigure()
    }
    
    private func setupTargets(for targets: UIButton...) {
        targets.forEach { $0.addTarget(self,
                                       action: #selector(didSelect(view:)),
                                       for: .touchUpInside) }
    }
    
    private func setupObservers() {
        viewDidRegisterObservers()
    }
    
    func viewDidConfigure() {
        gradientView.backgroundColor = .black.withAlphaComponent(0.5)
        titleLabel.text = viewModel.media.title
        viewWillAppear()
    }
    
    func viewDidRegisterObservers() {
        let interval = CMTime(value: 1, timescale: 1)
        observers?.timeObserverToken = mediaPlayerView.mediaPlayerLayer.player.addPeriodicTimeObserver(
            forInterval: interval,
            queue: .main) { [weak self] time in
                guard let self = self else { return }
                let timeElapsed = Float(time.seconds)
                let duration = Float(self.mediaPlayerView?.mediaPlayerLayer.player.currentItem?.duration.seconds ?? .zero).rounded()
                self.progressView.progress = timeElapsed / duration
                self.trackingSlider.value = timeElapsed
        }
    }
    
    func viewWillAppear() {
        startTimer(target: self, selector: #selector(viewWillDisappear))
        
        progressView.isHidden(true)
        gradientView.isHidden(false)
        playButton.isHidden(false)
        backwardButton.isHidden(false)
        forwardButton.isHidden(false)
        rotateButton.isHidden(false)
        airPlayButton.isHidden(false)
        muteButton.isHidden(false)
        trackingSlider.isHidden(false)
        startTimeLabel.isHidden(false)
        durationLabel.isHidden(false)
        titleLabel.isHidden(false)
        timeSeparatorLabel.isHidden(false)
    }
    
    @objc
    func viewWillDisappear() {
        timer.invalidate()
        
        progressView.isHidden(false)
        gradientView.isHidden(true)
        playButton.isHidden(true)
        backwardButton.isHidden(true)
        forwardButton.isHidden(true)
        rotateButton.isHidden(true)
        airPlayButton.isHidden(true)
        muteButton.isHidden(true)
        trackingSlider.isHidden(true)
        startTimeLabel.isHidden(true)
        durationLabel.isHidden(true)
        titleLabel.isHidden(true)
        timeSeparatorLabel.isHidden(true)
    }
    
    func buttonDidTap(_ view: UIButton) {
        guard let state = State(rawValue: view.tag) else { return }
        switch state {
        case .airPlay:
            print(state.rawValue)
        case .rotate:
            if UIDevice.current.orientation == .portrait
                || UIDevice.current.orientation == .unknown {
                AppDelegate.orientation = .landscapeRight
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue,
                                          forKey: "orientation")
                return
            }
            if UIDevice.current.orientation == .landscapeLeft
                || UIDevice.current.orientation == .landscapeRight {
                AppDelegate.orientation = .portrait
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue,
                                          forKey: "orientation")
            }
        case .backward:
            if mediaPlayerView.mediaPlayerLayer.player.currentItem?.currentTime() == .zero {
                if let player = mediaPlayerView.mediaPlayerLayer.player,
                   let duration = player.currentItem?.duration {
                    player.currentItem?.seek(to: duration, completionHandler: nil)
                }
            }
            let time = CMTime(value: 15, timescale: 1)
            DispatchQueue.main.async { [weak self] in
                guard
                    let self = self,
                    let player = self.mediaPlayerView.mediaPlayerLayer.player
                else { return }
                player.seek(to: player.currentTime() - time)
                let progress = Float(player.currentTime().seconds)
                    / Float(player.currentItem?.duration.seconds ?? .zero) - 10.0
                    / Float(player.currentItem?.duration.seconds ?? .zero)
                self.progressView.progress = progress
            }
        case .play:
            let player = mediaPlayerView.mediaPlayerLayer.player
            player?.timeControlStatus == .playing ? player?.pause() : player?.play()
        case .forward:
            let player = mediaPlayerView.mediaPlayerLayer.player
            if player?.currentItem?.currentTime() == player?.currentItem?.duration {
                player?.currentItem?.seek(to: .zero, completionHandler: nil)
            }
            let time = CMTime(value: 15, timescale: 1)
            player?.seek(to: player!.currentTime() + time)
            let progress = Float(player!.currentTime().seconds)
                / Float(player?.currentItem?.duration.seconds ?? .zero) + 10.0
                / Float(player?.currentItem?.duration.seconds ?? .zero)
            self.progressView.progress = progress
        case .mute:
            print(state.rawValue)
        }
    }
    
    @objc
    func didSelect(view: Any) {
        viewWillAppear()
        guard let view = view as? UIView else { return }
        if case let view as UIButton = view { buttonDidTap(view) }
    }
    
    func startTimer(target: Any, selector: Selector) {
        timer.schedule(timeInterval: configuration.durationThreshold,
                       target: target,
                       selector: selector,
                       repeats: configuration.repeats)
    }
    
    func removeObservers() {
        guard let timeObserverToken = observers?.timeObserverToken else { return }
        print("Removed `MediaPlayerOverlayView` observers.")
        mediaPlayerView?.mediaPlayerLayer.player.removeTimeObserver(timeObserverToken)
    }
}

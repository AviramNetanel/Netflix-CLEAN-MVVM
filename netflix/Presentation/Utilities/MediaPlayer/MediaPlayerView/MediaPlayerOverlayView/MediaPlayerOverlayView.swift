//
//  MediaPlayerOverlayView.swift
//  netflix
//
//  Created by Zach Bazov on 06/10/2022.
//

import AVKit

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
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
    func viewDidRegisterObservers()
    func viewDidConfigure()
    func didSelect(view: Any)
    func buttonDidTap(_ view: UIButton)
    func value(for slider: UISlider)
}

// MARK: - ViewOutput protocol

private protocol ViewOutput {
    var observers: MediaPlayerObservers { get }
    var configuration: MediaPlayerOverlayViewConfiguration! { get }
    var timer: ScheduledTimer { get }
    var mediaPlayerView: MediaPlayerView! { get }
    var viewModel: MediaPlayerOverlayViewViewModel { get }
    var mediaPlayerViewModel: MediaPlayerViewViewModel! { get }
}

// MARK: - View typealias

private typealias View = ViewInput & ViewOutput

// MARK: - MediaPlayerOverlayView class

final class MediaPlayerOverlayView: UIView, View, ViewInstantiable {
    
    private enum Item: Int {
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
    
    fileprivate var configuration: MediaPlayerOverlayViewConfiguration!
    fileprivate(set) var observers = MediaPlayerObservers()
    fileprivate var timer = ScheduledTimer()
    
    fileprivate weak var mediaPlayerView: MediaPlayerView!
    fileprivate let viewModel = MediaPlayerOverlayViewViewModel()
    fileprivate var mediaPlayerViewModel: MediaPlayerViewViewModel!
    
    deinit {
        timer.invalidate()
        removeObservers()
        mediaPlayerView = nil
        mediaPlayerViewModel = nil
        configuration = nil
    }

    static func create(on parent: MediaPlayerView) -> MediaPlayerOverlayView {
        let view = MediaPlayerOverlayView(frame: parent.bounds)
        view.nibDidLoad()
        view.mediaPlayerViewModel = parent.viewModel
        view.mediaPlayerView = parent
        createConfiguration(on: view)
        view.viewDidLoad()
        return view
    }
    
    @discardableResult
    private static func createConfiguration(on view: MediaPlayerOverlayView) -> MediaPlayerOverlayViewConfiguration {
        view.configuration = .init(durationThreshold: 3.0, repeats: true)
        return view.configuration
    }
    
    fileprivate func viewDidLoad() {
        setupObservers()
        setupSubviews()
    }
    
    fileprivate func viewDidConfigure() {
        guard
            let player = mediaPlayerView.mediaPlayer.player as AVPlayer?,
            let item = player.currentItem
        else { return }
        switch item.status {
        case .failed:
            playButton.isEnabled = false
            trackingSlider.isEnabled = false
            startTimeLabel.isEnabled = false
            durationLabel.isEnabled = false
        case .readyToPlay:
            playButton.isEnabled = true
            let newDurationInSeconds = Float(item.duration.seconds)
            let currentTime = Float(CMTimeGetSeconds(player.currentTime()))
            trackingSlider.isEnabled = true
            startTimeLabel.isEnabled = true
            durationLabel.isEnabled = true
            
            progressView.setProgress(currentTime, animated: true)
            trackingSlider.maximumValue = newDurationInSeconds
            trackingSlider.value = currentTime
            startTimeLabel.text = viewModel.timeString(currentTime)
            durationLabel.text = viewModel.timeString(newDurationInSeconds)
        default:
            playButton.isEnabled = false
            trackingSlider.isEnabled = false
            startTimeLabel.isEnabled = false
            durationLabel.isEnabled = false
        }
    }
    
    fileprivate func viewDidRegisterObservers() {
        guard let player = mediaPlayerView.mediaPlayer.player as AVPlayer? else { return }
        
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let interval = CMTime(value: 1, timescale: timeScale)
        observers.timeObserverToken = player.addPeriodicTimeObserver(
            forInterval: interval,
            queue: .main) { [weak self] time in
                guard let self = self else { return }
                let timeElapsed = Float(time.seconds)
                let duration = Float(player.currentItem?.duration.seconds ?? .zero).rounded()
                self.progressView.progress = timeElapsed / duration
                self.trackingSlider.value = timeElapsed
                self.startTimeLabel.text = self.viewModel.timeString(timeElapsed)
        }
        
        observers.cancelBag = []
        observers.playerItemDidEndPlayingObserver = NotificationCenter.default
            .publisher(for: .AVPlayerItemDidPlayToEndTime)
            .sink { _ in player.seek(to: CMTime.zero)
        }
        observers.playerItemDidEndPlayingObserver.store(in: &observers.cancelBag)
        
        observers.playerTimeControlStatusObserver = player.observe(
            \AVPlayer.timeControlStatus,
             options: [.initial, .new],
             changeHandler: { [weak self] _, _ in self?.setupPlayButton() })
        
        observers.playerItemFastForwardObserver = player.observe(
            \AVPlayer.currentItem?.canPlayFastForward,
             options: [.initial, .new],
             changeHandler: { [weak self] player, _ in
                 self?.forwardButton.isEnabled = player.currentItem?.canPlayFastForward ?? false
             })
        
        observers.playerItemReverseObserver = player.observe(
            \AVPlayer.currentItem?.canPlayReverse,
             options: [.initial],
             changeHandler: { [weak self] player, _ in
                 self?.backwardButton.isEnabled = player.currentItem?.canPlayReverse ?? false
             })
        
        observers.playerItemFastReverseObserver = player.observe(
            \AVPlayer.currentItem?.canPlayFastReverse,
             options: [.initial, .new],
             changeHandler: { [weak self] player, _ in
                 self?.backwardButton.isEnabled = player.currentItem?.canPlayFastReverse ?? false
             })
        
        observers.playerItemStatusObserver = player.observe(
            \AVPlayer.currentItem?.status,
             options: [.initial, .new],
             changeHandler: { [weak self] _, _ in self?.viewDidConfigure() })
    }
    
    private func setupSubviews() {
        setupTargets(for: airPlayButton,
                     rotateButton,
                     backwardButton,
                     playButton,
                     forwardButton,
                     muteButton)
        
        gradientView.backgroundColor = .black.withAlphaComponent(0.5)
        
        titleLabel.text = mediaPlayerViewModel.media.title
        
        trackingSlider.addTarget(self,
                                 action: #selector(value(for:)),
                                 for: .valueChanged)
        
        viewWillAppear()
    }
    
    private func setupTargets(for targets: UIButton...) {
        targets.forEach { $0.addTarget(self,
                                       action: #selector(didSelect(view:)),
                                       for: .touchUpInside) }
    }
    
    private func setupObservers() {
        viewDidRegisterObservers()
    }
    
    private func setupPlayButton() {
        guard let player = mediaPlayerView.mediaPlayer.player as AVPlayer? else { return }
        
        var systemImage: UIImage
        switch player.timeControlStatus {
        case .playing:
            systemImage = .init(systemName: "pause")!
        case .paused,
                .waitingToPlayAtSpecifiedRate:
            systemImage = .init(systemName: "arrowtriangle.right.fill")!
        default:
            systemImage = .init(systemName: "pause")!
        }
        
        guard let image = systemImage as UIImage? else { return }
        playButton.setImage(image, for: .normal)
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
    
    @objc
    func didSelect(view: Any) {
        viewWillAppear()
        guard let view = view as? UIView else { return }
        if case let view as UIButton = view { buttonDidTap(view) }
    }
    
    func buttonDidTap(_ view: UIButton) {
        guard let item = Item(rawValue: view.tag) else { return }
        switch item {
        case .airPlay:
            print(item.rawValue)
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
            if mediaPlayerView.mediaPlayer.player.currentItem?.currentTime() == .zero {
                if let player = mediaPlayerView.mediaPlayer.player as AVPlayer?,
                   let duration = player.currentItem?.duration {
                    player.currentItem?.seek(to: duration, completionHandler: nil)
                }
            }
            let time = CMTime(value: 15, timescale: 1)
            DispatchQueue.main.async { [weak self] in
                guard
                    let self = self,
                    let player = self.mediaPlayerView.mediaPlayer.player as AVPlayer?
                else { return }
                player.seek(to: player.currentTime() - time)
                let progress = Float(player.currentTime().seconds)
                    / Float(player.currentItem?.duration.seconds ?? .zero) - 10.0
                    / Float(player.currentItem?.duration.seconds ?? .zero)
                self.progressView.progress = progress
            }
        case .play:
            let player = mediaPlayerView.mediaPlayer.player
            player.timeControlStatus == .playing ? player.pause() : player.play()
        case .forward:
            let player = mediaPlayerView.mediaPlayer.player
            if player.currentItem?.currentTime() == player.currentItem?.duration {
                player.currentItem?.seek(to: .zero, completionHandler: nil)
            }
            let time = CMTime(value: 15, timescale: 1)
            player.seek(to: player.currentTime() + time)
            let progress = Float(player.currentTime().seconds)
                / Float(player.currentItem?.duration.seconds ?? .zero) + 10.0
                / Float(player.currentItem?.duration.seconds ?? .zero)
            self.progressView.progress = progress
        case .mute:
            print(item.rawValue)
        }
    }
    
    @objc
    func value(for slider: UISlider) {
        let player = mediaPlayerView.mediaPlayer.player
        let newTime = CMTime(seconds: Double(slider.value), preferredTimescale: 600)
        player.seek(to: newTime, toleranceBefore: .zero, toleranceAfter: .zero)
        progressView.setProgress(progressView.progress + Float(newTime.seconds), animated: true)
    }
    
    func startTimer(target: Any, selector: Selector) {
        timer.schedule(timeInterval: configuration.durationThreshold,
                       target: target,
                       selector: selector,
                       repeats: configuration.repeats)
    }
    
    func removeObservers() {
        print("Removed `MediaPlayerOverlayView` observers.")
        observers.playerItemStatusObserver?.invalidate()
        observers.playerItemFastForwardObserver?.invalidate()
        observers.playerItemReverseObserver?.invalidate()
        observers.playerItemFastReverseObserver?.invalidate()
        observers.playerTimeControlStatusObserver?.invalidate()
        observers.cancelBag?.removeAll()
        observers.timeObserverToken = nil
        observers.playerItemStatusObserver = nil
        observers.playerItemFastForwardObserver = nil
        observers.playerItemReverseObserver = nil
        observers.playerItemFastReverseObserver = nil
        observers.playerTimeControlStatusObserver = nil
        observers.playerItemDidEndPlayingObserver = nil
        observers.cancelBag = nil
    }
}

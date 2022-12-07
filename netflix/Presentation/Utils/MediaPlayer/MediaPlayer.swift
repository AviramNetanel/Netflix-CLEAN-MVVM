//
//  MediaPlayer.swift
//  netflix
//
//  Created by Zach Bazov on 11/10/2022.
//

import AVKit

protocol MediaPlayerDelegate: AnyObject {
    func playerDidPlay(_ mediaPlayer: MediaPlayer)
    func playerDidStop(_ mediaPlayer: MediaPlayer)
    func player(_ mediaPlayer: MediaPlayer, willReplaceItem item: AVPlayerItem?)
    func player(_ mediaPlayer: MediaPlayer, willVerifyUrl url: URL) -> Bool
}

private protocol MediaPlayerOutput {
    var player: AVPlayer { get }
    var mediaPlayerLayer: MediaPlayerLayer! { get }
}

private typealias MediaPlaying = MediaPlayerOutput

struct MediaPlayer: MediaPlaying {
    let player = AVPlayer()
    var mediaPlayerLayer: MediaPlayerLayer!
    
    static func create(on parent: UIView) -> MediaPlayer {
        let mediaPlayerLayer = MediaPlayerLayer(frame: parent.bounds)
        let view = MediaPlayer(mediaPlayerLayer: mediaPlayerLayer)
        parent.addSubview(view.mediaPlayerLayer)
        view.mediaPlayerLayer.constraintToSuperview(parent)
        view.mediaPlayerLayer.player = view.player
        return view
    }
}

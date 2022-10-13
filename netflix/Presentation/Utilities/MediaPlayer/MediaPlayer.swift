//
//  MediaPlayer.swift
//  netflix
//
//  Created by Zach Bazov on 11/10/2022.
//

import AVKit

// MARK: - MediaPlayerOutput protocol

private protocol MediaPlayerOutput {
    var player: AVPlayer { get }
    var mediaPlayerLayer: MediaPlayerLayer! { get }
}

// MARK: - MediaPlayer struct

struct MediaPlayer: MediaPlayerOutput {
    
    let player = AVPlayer()
    var mediaPlayerLayer: MediaPlayerLayer!
    
    static func create(on parent: UIView) -> MediaPlayer {
        let mediaPlayerLayer = MediaPlayerLayer(frame: parent.bounds)
        let view = MediaPlayer(mediaPlayerLayer: mediaPlayerLayer)
        view.mediaPlayerLayer.translatesAutoresizingMaskIntoConstraints = false
        parent.addSubview(view.mediaPlayerLayer)
        view.mediaPlayerLayer.constraintToSuperview(parent)
        view.mediaPlayerLayer.player = view.player
        return view
    }
}

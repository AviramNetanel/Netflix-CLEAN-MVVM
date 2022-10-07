//
//  MediaPlayerLayer.swift
//  netflix
//
//  Created by Zach Bazov on 06/10/2022.
//

import AVKit

// MARK: - MediaPlayerLayer class

final class MediaPlayerLayer: UIView {
    
    override class var layerClass: AnyClass { AVPlayerLayer.self }
    
    var playerLayer: AVPlayerLayer { layer as! AVPlayerLayer }
    
    var player: AVPlayer! {
        get { playerLayer.player }
        set { playerLayer.player = newValue }
    }
}

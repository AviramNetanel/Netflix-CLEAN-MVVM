//
//  MediaPlayerViewItem.swift
//  netflix
//
//  Created by Zach Bazov on 06/10/2022.
//

import AVKit

// MARK: - MediaPlayerViewItem class

final class MediaPlayerViewItem: AVPlayerItem {
    
    override init(asset: AVAsset, automaticallyLoadedAssetKeys: [String]?) {
        super.init(asset: asset, automaticallyLoadedAssetKeys: automaticallyLoadedAssetKeys)
    }
    
    convenience init(with media: Media) {
        let url = URL(string: media.previewURL ?? "")!
        self.init(asset: AVAsset(url: url),
                  automaticallyLoadedAssetKeys: nil)
    }
}

//
//  MediaPlayerViewItem.swift
//  netflix
//
//  Created by Zach Bazov on 06/10/2022.
//

import AVKit

final class MediaPlayerViewItem: AVPlayerItem {
    override init(asset: AVAsset,
                  automaticallyLoadedAssetKeys: [String]?) {
        super.init(asset: asset,
                   automaticallyLoadedAssetKeys: automaticallyLoadedAssetKeys)
    }
    
    convenience init?(with media: Media) {
        let string = "https://file-examples.com/wp-content/uploads/2018/04/file_example_MOV_1920_2_2MB.mov"
      let url = URL(string: media.type == .film
                    ? media.resources.previewUrl
                    : (media.resources.trailers.first ?? string))
        self.init(asset: AVAsset(url: url ?? .init(string: string)!),
                  automaticallyLoadedAssetKeys: nil)
    }
}

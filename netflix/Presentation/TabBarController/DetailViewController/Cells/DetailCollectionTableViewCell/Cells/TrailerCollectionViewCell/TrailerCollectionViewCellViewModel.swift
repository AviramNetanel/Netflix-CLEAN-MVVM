//
//  TrailerCollectionViewCellViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 11/10/2022.
//

import Foundation

struct TrailerCollectionViewCellViewModel {
    let title: String
    var posterImagePath: String
    var posterImageIdentifier: NSString
    var posterImageURL: URL!
    
    init(with media: Media) {
        self.title = media.title
        self.posterImagePath = media.resources.previewPoster
        self.posterImageIdentifier = .init(string: "detailPoster_\(media.slug)")
        self.posterImageURL = .init(string: self.posterImagePath)
    }
}

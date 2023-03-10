//
//  EpisodeCollectionViewCellViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 12/10/2022.
//

import Foundation

struct EpisodeCollectionViewCellViewModel {
    let media: Media
    let posterImagePath: String
    let posterImageIdentifier: NSString
    var posterImageURL: URL!
    var season: Season!
    
    init(with viewModel: DetailViewModel) {
        self.media = viewModel.media
        self.posterImagePath = self.media.resources.previewPoster
        self.posterImageIdentifier = .init(string: "detailPoster_\(self.media.slug)")
        self.posterImageURL = .init(string: self.posterImagePath)
        if let season = viewModel.season.value as Season? {
            self.season = season
        }
    }
}

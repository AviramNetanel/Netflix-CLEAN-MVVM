//
//  EpisodeCollectionViewCellViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 12/10/2022.
//

import Foundation

// MARK: - ViewModelInput protocol

private protocol ViewModelInput {}

// MARK: - ViewModelOutput protocol

private protocol ViewModelOutput {
    var media: Media { get }
    var posterImagePath: String { get }
    var posterImageIdentifier: NSString { get }
    var posterImageURL: URL! { get }
    var season: Season! { get }
}

// MARK: - ViewModel typealias

private typealias ViewModel = ViewModelInput & ViewModelOutput

// MARK: - EpisodeCollectionViewCellViewModel struct

struct EpisodeCollectionViewCellViewModel: ViewModel {
    
    let media: Media
    let posterImagePath: String
    let posterImageIdentifier: NSString
    var posterImageURL: URL!
    var season: Season!
    
    init(with viewModel: DetailViewModel) {
        self.media = viewModel.media
        self.posterImagePath = viewModel.media.detailCover
        self.posterImageIdentifier = .init(string: "detailposter_\(viewModel.media.slug)")
        self.posterImageURL = .init(string: self.posterImagePath)
        if let season = viewModel.season.value as Season? {
            self.season = season
        }
    }
}

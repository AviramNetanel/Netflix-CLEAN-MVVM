//
//  TrailerCollectionViewCellViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 11/10/2022.
//

import Foundation

// MARK: - ViewModelInput protocol

private protocol ViewModelInput {}

// MARK: - ViewModelOutput protocol

private protocol ViewModelOutput {
    var title: String { get }
    var posterImagePath: String { get }
    var posterImageIdentifier: NSString { get }
    var posterImageURL: URL! { get }
}

// MARK: - ViewModel typealias

private typealias ViewModel = ViewModelInput & ViewModelOutput

// MARK: - TrailerCollectionViewCellViewModel struct

struct TrailerCollectionViewCellViewModel: ViewModel {
    
    let title: String
    var posterImagePath: String
    var posterImageIdentifier: NSString
    var posterImageURL: URL!
    
    init(with media: Media) {
        self.title = media.title
        self.posterImagePath = media.resources.previewPoster
        self.posterImageIdentifier = .init(string: "detailposter_\(media.slug)")
        self.posterImageURL = .init(string: self.posterImagePath)
    }
}

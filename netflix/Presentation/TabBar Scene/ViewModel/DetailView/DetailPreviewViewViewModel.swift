//
//  DetailPreviewViewViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import Foundation

// MARK: - ViewModelInput protocol

private protocol ViewModelInput {}

// MARK: - ViewModelOutput protocol

private protocol ViewModelOutput {}

// MARK: - ViewModel typealias

private typealias ViewModel = ViewModelInput & ViewModelOutput

// MARK: - DetailPreviewViewViewModel struct

struct DetailPreviewViewViewModel: ViewModel {
    
    let title: String
    let slug: String
    let posterImagePath: String
    let identifier: NSString
    let url: URL
    
    init(with media: Media) {
        self.title = media.title
        self.slug = media.slug
        self.posterImagePath = media.detailCover
        self.identifier = "detailPoster_\(media.slug)" as NSString
        self.url = URL(string: self.posterImagePath)!
    }
}

//
//  DefaultDetailPreviewViewViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import Foundation

// MARK: - DetailPreviewViewViewModelInput protocol

private protocol DetailPreviewViewViewModelInput {}

// MARK: - DetailPreviewViewViewModelOutput protocol

private protocol DetailPreviewViewViewModelOutput {}

// MARK: - DetailPreviewViewViewModel protocol

private protocol DetailPreviewViewViewModel: DetailPreviewViewViewModelInput,
                                             DetailPreviewViewViewModelOutput {}

// MARK: - DetailPreviewViewViewModel struct

struct DefaultDetailPreviewViewViewModel {
    
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

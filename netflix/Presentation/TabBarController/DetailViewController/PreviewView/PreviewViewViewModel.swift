//
//  PreviewViewViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import Foundation

// MARK: - PreviewViewViewModel struct

struct PreviewViewViewModel {
    
    let title: String
    let slug: String
    let posterImagePath: String
    let identifier: NSString
    let url: URL
    
    init(with media: Media) {
        self.title = media.title
        self.slug = media.slug
        self.posterImagePath = media.resources.previewPoster
        self.identifier = "detailposter_\(media.slug)" as NSString
        self.url = URL(string: self.posterImagePath)!
    }
}

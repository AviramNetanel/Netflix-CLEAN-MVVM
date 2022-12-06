//
//  OpaqueViewViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 20/09/2022.
//

import Foundation

// MARK: - OpaqueViewViewModel struct

struct OpaqueViewViewModel {
    
    let imagePath: String
    let identifier: NSString
    let imageURL: URL
    
    init(with media: Media) {
        self.imagePath = media.resources.displayPoster
        self.identifier = "displayPoster_\(media.slug)" as NSString
        self.imageURL = URL(string: self.imagePath)!
    }
}

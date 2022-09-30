//
//  DefaultOpaqueViewViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 20/09/2022.
//

import Foundation

// MARK: - OpaqueViewViewModelInput protocol

private protocol OpaqueViewViewModelInput {
    var imagePath: String { get }
}

// MARK: - OpaqueViewViewModelOutput protocol

private protocol OpaqueViewViewModelOutput {}

// MARK: - OpaqueViewViewModel protocol

private protocol OpaqueViewViewModel: OpaqueViewViewModelInput,
                                      OpaqueViewViewModelOutput {}

// MARK: - DefaultOpaqueViewViewModel struct

struct DefaultOpaqueViewViewModel {
    
    let imagePath: String
    let identifier: NSString
    let imageURL: URL
    
    init(with media: Media) {
        self.imagePath = media.displayCover
        self.identifier = "displayPoster_\(media.slug)" as NSString
        self.imageURL = URL(string: self.imagePath)!
    }
}

//
//  OpaqueViewViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 20/09/2022.
//

import Foundation

// MARK: - ViewModelInput protocol

private protocol ViewModelInput {
    var imagePath: String { get }
}

// MARK: - ViewModelOutput protocol

private protocol ViewModelOutput {}

// MARK: - ViewModel typealias

private typealias ViewModel = ViewModelInput & ViewModelOutput

// MARK: - OpaqueViewViewModel struct

struct OpaqueViewViewModel: ViewModel {
    
    let imagePath: String
    let identifier: NSString
    let imageURL: URL
    
    init(with media: Media) {
        self.imagePath = media.displayCover
        self.identifier = "displayPoster_\(media.slug)" as NSString
        self.imageURL = URL(string: self.imagePath)!
    }
}

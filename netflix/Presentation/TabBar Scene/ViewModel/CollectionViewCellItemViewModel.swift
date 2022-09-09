//
//  CollectionViewCellItemViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 08/09/2022.
//

import Foundation

// MARK: - CollectionViewCellItemViewModel struct

struct CollectionViewCellItemViewModel {
    
    enum LogoAlignment: String {
        case top
        case midTop = "mid-top"
        case mid
        case midBottom = "mid-bottom"
        case bottom
    }
    
    let title: String
    let posterImagePath: String
    let logoImagePath: String
    let logoPosition: LogoAlignment
    let indexPath: IndexPath
    
    init(media: Media, indexPath: IndexPath) {
        self.indexPath = indexPath
        self.title = media.title
        self.posterImagePath = media.covers.first!
        self.logoImagePath = media.logos.first!
        self.logoPosition = .init(rawValue: media.logoPosition)!
    }
}

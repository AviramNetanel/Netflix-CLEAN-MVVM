//
//  CollectionViewCellItemViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 08/09/2022.
//

import Foundation

// MARK: - CollectionViewCellItemViewModel struct

struct CollectionViewCellItemViewModel {
    let title: String
    let posterImagePath: String
    let indexPath: IndexPath
    init(media: Media, indexPath: IndexPath) {
        self.indexPath = indexPath
        self.title = media.title
        self.posterImagePath = media.covers.first!
    }
}

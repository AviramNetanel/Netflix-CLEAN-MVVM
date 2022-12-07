//
//  DetailDescriptionViewViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 04/10/2022.
//

import Foundation

struct DetailDescriptionViewViewModel {
    let description: String
    let cast: String
    let writers: String
    
    init(with media: Media) {
        self.description = media.description
        self.cast = media.cast
        self.writers = media.writers
    }
}

//
//  StandardItemViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 06/09/2022.
//

import Foundation

struct StandardItemViewModel {
    let title: String
    let covers: [String]
}

extension StandardItemViewModel {
    init(media: Media) {
        self.title = media.title
        self.covers = media.covers
    }
    init(section: Section) {
        self.title = section.title
        self.covers = []
    }
}

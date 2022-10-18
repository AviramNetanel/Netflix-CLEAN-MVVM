//
//  Section.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import Foundation

// MARK: - Section class

final class Section {
    
    var id: Int
    var title: String
    var media: [Media]
    
    init(id: Int,
         title: String,
         media: [Media]) {
        self.id = id
        self.title = title
        self.media = media
    }
}

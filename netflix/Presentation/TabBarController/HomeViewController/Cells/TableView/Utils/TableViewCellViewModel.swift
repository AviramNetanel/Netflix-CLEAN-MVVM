//
//  TableViewCellViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 08/09/2022.
//

import Foundation

// MARK: - TableViewCellViewModel struct

struct TableViewCellViewModel {
    
    let id: Int
    let title: String
    let media: [Media]
    
    init(section: Section) {
        self.id = section.id
        self.title = section.title
        self.media = section.media
    }
}

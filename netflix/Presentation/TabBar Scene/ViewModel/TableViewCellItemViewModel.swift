//
//  TableViewCellItemViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 08/09/2022.
//

import Foundation

// MARK: - TableViewCellItemViewModel struct

struct TableViewCellItemViewModel {
    let id: Int
    let title: String
    let tvshows: [Media]
    let movies: [Media]
    init(section: Section) {
        self.id = section.id
        self.title = section.title
        self.tvshows = section.tvshows ?? []
        self.movies = section.movies ?? []
    }
}

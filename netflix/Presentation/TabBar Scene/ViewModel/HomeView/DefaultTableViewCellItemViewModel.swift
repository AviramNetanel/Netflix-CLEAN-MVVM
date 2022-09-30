//
//  DefaultTableViewCellItemViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 08/09/2022.
//

import Foundation

private protocol TableViewCellItemViewModel {
    var id: Int { get }
    var title: String { get }
    var tvshows: [Media] { get }
    var movies: [Media] { get }
}

// MARK: - DefaultTableViewCellItemViewModel struct

struct DefaultTableViewCellItemViewModel: TableViewCellItemViewModel {
    
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

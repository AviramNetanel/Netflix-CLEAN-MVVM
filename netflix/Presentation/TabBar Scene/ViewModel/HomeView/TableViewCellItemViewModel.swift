//
//  TableViewCellItemViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 08/09/2022.
//

import Foundation

// MARK: - ViewModelInput protocol

private protocol ViewModelInput {}

// MARK: - ViewModelOutput protocol

private protocol ViewModelOutput {
    var id: Int { get }
    var title: String { get }
    var tvshows: [Media] { get }
    var movies: [Media] { get }
}

// MARK: - ViewModel typealias

private typealias ViewModel = ViewModelInput & ViewModelOutput

// MARK: - TableViewCellItemViewModel struct

struct TableViewCellItemViewModel: ViewModel {
    
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

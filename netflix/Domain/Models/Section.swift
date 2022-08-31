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
    var tvshows: [Media]?
    var movies: [Media]?
    
    init(id: Int, title: String, tvshows: [Media]?, movies: [Media]?) {
        self.id = id
        self.title = title
        self.tvshows = tvshows ?? []
        self.movies = movies ?? []
    }
}

//
//  Season.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import Foundation

// MARK: - Season struct

struct Season {
    var tvShow: String
    var title: String
    var slug: String
    var season: Int
    var media: [Episode]
}

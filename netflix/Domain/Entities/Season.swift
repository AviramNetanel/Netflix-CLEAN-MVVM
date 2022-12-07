//
//  Season.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import Foundation

struct Season {
    var mediaId: String
    var title: String
    var slug: String
    var season: Int
    var episodes: [Episode]
}

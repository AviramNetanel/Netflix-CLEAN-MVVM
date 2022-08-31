//
//  Section+Decodable.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import Foundation

// MARK: - Decodable implementation

extension Section: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id,
             title,
             tvshows,
             movies
    }
    
    convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let title = try container.decode(String.self, forKey: .title)
        let tvshows = try container.decode([Media].self, forKey: .tvshows)
        let movies = try container.decode([Media].self, forKey: .movies)
        
        self.init(id: id, title: title, tvshows: tvshows, movies: movies)
        
        self.id = id
        self.title = title
        self.tvshows = tvshows
        self.movies = movies
    }
}

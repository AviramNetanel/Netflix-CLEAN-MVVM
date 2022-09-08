//
//  SectionDTO+DataMapping.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import Foundation

// MARK: - SectionDTO struct

struct SectionDTO: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case id,
             title,
             tvshows,
             movies
    }
    
    let id: Int
    let title: String
    var tvshows: [MediaDTO]
    var movies: [MediaDTO]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let title = try container.decode(String.self, forKey: .title)
        let tvshows = try container.decode([MediaDTO].self, forKey: .tvshows)
        let movies = try container.decode([MediaDTO].self, forKey: .movies)
        
        self.id = id
        self.title = title
        self.tvshows = tvshows
        self.movies = movies
    }
}

// MARK: - DataMapping

extension SectionDTO {
    func toDomain() -> Section {
        return .init(id: id,
                     title: title,
                     tvshows: tvshows.map { $0.toDomain() },
                     movies: movies.map { $0.toDomain() })
    }
}

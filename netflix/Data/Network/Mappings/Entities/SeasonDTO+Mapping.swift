//
//  SeasonDTO+Mapping.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import Foundation

// MARK: - SeasonDTO struct

struct SeasonDTO: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case mediaId,
             title,
             slug,
             season,
             episodes
    }
    
    let mediaId: String
    let title: String
    let slug: String
    let season: Int
    let episodes: [EpisodeDTO]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let mediaId = try container.decode(String.self, forKey: .mediaId)
        let title = try container.decode(String.self, forKey: .title)
        let slug = try container.decode(String.self, forKey: .slug)
        let season = try container.decode(Int.self, forKey: .season)
        let episodes = try container.decode([EpisodeDTO].self, forKey: .episodes)
        
        self.mediaId = mediaId
        self.title = title
        self.slug = slug
        self.season = season
        self.episodes = episodes
    }
}

// MARK: - Mapping

extension SeasonDTO {
    func toDomain() -> Season {
        return .init(mediaId: mediaId,
                     title: title,
                     slug: slug,
                     season: season,
                     episodes: episodes.map { $0.toDomain() })
    }
}

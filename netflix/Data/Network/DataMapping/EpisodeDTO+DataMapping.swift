//
//  EpisodeDTO+DataMapping.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import Foundation

// MARK: - EpisodeDTO struct

struct EpisodeDTO: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id,
             tvShow,
             title,
             slug,
             season,
             episode,
             url
    }
    
    let id: String
    let tvShow: String
    let title: String
    let slug: String
    let season: Int
    let episode: Int
    let url: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(String.self, forKey: .id)
        let tvShow = try container.decode(String.self, forKey: .tvShow)
        let title = try container.decode(String.self, forKey: .title)
        let slug = try container.decode(String.self, forKey: .slug)
        let season = try container.decode(Int.self, forKey: .season)
        let episode = try container.decode(Int.self, forKey: .episode)
        let url = try container.decode(String.self, forKey: .url)
        
        self.id = id
        self.tvShow = tvShow
        self.title = title
        self.slug = slug
        self.season = season
        self.episode = episode
        self.url = url
    }
}

// MARK: - DataMapping

extension EpisodeDTO {
    func toDomain() -> Episode {
        return .init(id: id,
                     tvShow: tvShow,
                     title: title,
                     slug: slug,
                     season: season,
                     episode: episode,
                     url: url)
    }
}

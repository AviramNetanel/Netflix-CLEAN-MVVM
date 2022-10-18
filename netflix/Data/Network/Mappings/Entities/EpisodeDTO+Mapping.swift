//
//  EpisodeDTO+Mapping.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import Foundation

// MARK: - EpisodeDTO struct

struct EpisodeDTO: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case mediaId,
             title,
             slug,
             season,
             episode,
             url
    }
    
    let mediaId: String
    let title: String
    let slug: String
    let season: Int
    let episode: Int
    let url: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let mediaId = try container.decode(String.self, forKey: .mediaId)
        let title = try container.decode(String.self, forKey: .title)
        let slug = try container.decode(String.self, forKey: .slug)
        let season = try container.decode(Int.self, forKey: .season)
        let episode = try container.decode(Int.self, forKey: .episode)
        let url = try container.decode(String.self, forKey: .url)
        
        self.mediaId = mediaId
        self.title = title
        self.slug = slug
        self.season = season
        self.episode = episode
        self.url = url
    }
}

// MARK: - Mapping

extension EpisodeDTO {
    func toDomain() -> Episode {
        return .init(mediaId: mediaId,
                     title: title,
                     slug: slug,
                     season: season,
                     episode: episode,
                     url: url)
    }
}

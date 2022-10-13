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
        case tvShow,
             title,
             slug,
             season,
             media
    }
    
    let tvShow: String
    let title: String
    let slug: String
    let season: Int
    let media: [EpisodeDTO]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let tvShow = try container.decode(String.self, forKey: .tvShow)
        let title = try container.decode(String.self, forKey: .title)
        let slug = try container.decode(String.self, forKey: .slug)
        let season = try container.decode(Int.self, forKey: .season)
        let media = try container.decode([EpisodeDTO].self, forKey: .media)
        
        self.tvShow = tvShow
        self.title = title
        self.slug = slug
        self.season = season
        self.media = media
    }
}

// MARK: - Mapping

extension SeasonDTO {
    func toDomain() -> Season {
        return .init(tvShow: tvShow,
                     title: title,
                     slug: slug,
                     season: season,
                     media: media.map { $0.toDomain() })
    }
}

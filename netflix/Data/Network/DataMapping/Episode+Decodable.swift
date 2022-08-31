//
//  Episode+Decodable.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import Foundation

// MARK: - Decodable implementation

extension Episode: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id,
             tvShow,
             title,
             slug,
             season,
             episode,
             url
    }
    
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

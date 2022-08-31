//
//  Season+Decodable.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import Foundation

// MARK: - Decodable implementation

extension Season: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case tvShow,
             title,
             slug,
             season,
             media
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let tvShow = try container.decode(String.self, forKey: .tvShow)
        let title = try container.decode(String.self, forKey: .title)
        let slug = try container.decode(String.self, forKey: .slug)
        let season = try container.decode(Int.self, forKey: .season)
        let media = try container.decode([Episode].self, forKey: .media)
        
        self.tvShow = tvShow
        self.title = title
        self.slug = slug
        self.season = season
        self.media = media
    }
}

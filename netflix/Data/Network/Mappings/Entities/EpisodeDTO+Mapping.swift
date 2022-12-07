//
//  EpisodeDTO+Mapping.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import Foundation

struct EpisodeDTO: Decodable {
    let mediaId: String
    let title: String
    let slug: String
    let season: Int
    let episode: Int
    let url: String
}

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

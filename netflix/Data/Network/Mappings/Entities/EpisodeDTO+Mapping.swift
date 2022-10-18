//
//  EpisodeDTO+Mapping.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import Foundation

// MARK: - EpisodeDTO struct

struct EpisodeDTO: Decodable {
    let mediaId: String
    let title: String
    let slug: String
    let season: Int
    let episode: Int
    let url: String
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

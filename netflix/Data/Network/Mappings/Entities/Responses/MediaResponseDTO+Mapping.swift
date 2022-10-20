//
//  MediaResponseDTO+Mapping.swift
//  netflix
//
//  Created by Zach Bazov on 18/10/2022.
//

import Foundation
import CoreData

// MARK: - MediaResponseDTO struct

struct MediaResponseDTO: Decodable {
    let status: String
    let data: MediaDTO
}

// MARK: - Mapping

extension MediaResponseDTO {
    
    func toDomain() -> MediaResponse {
        return .init(status: status,
                     data: data.toDomain())
    }
    
    func toEntity(in context: NSManagedObjectContext) -> MediaResponseEntity {
        let entity: MediaResponseEntity = .init(context: context)
        entity.id = data.id
        entity.type = data.type
        entity.title = data.title
        entity.slug = data.slug
        entity.createdAt = data.createdAt
        entity.rating = data.rating
        entity.desc = data.description
        entity.cast = data.cast
        entity.writers = data.writers
        entity.duration = data.duration
        entity.length = data.length
        entity.genres = data.genres
        entity.hasWatched = data.hasWatched
        entity.isHD = data.isHD
        entity.isExclusive = data.isExclusive
        entity.isNewRelease = data.isNewRelease
        entity.isSecret = data.isSecret
        entity.resources = data.resources
        entity.seasons = data.seasons
        entity.numberOfEpisodes = Int32(data.numberOfEpisodes!)
        return entity
    }
}

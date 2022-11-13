//
//  MediaResponseDTO+Mapping.swift
//  netflix
//
//  Created by Zach Bazov on 18/10/2022.
//

import CoreData

// MARK: - MediaResponseDTO struct

struct MediaResponseDTO {
    
    struct GET {
        
        struct One: Decodable {
            let status: String
            let data: MediaDTO
        }
        
        struct Many: Decodable {
            let status: String
            let results: Int
            let data: [MediaDTO]
        }
    }
}

// MARK: - Mapping

extension MediaResponseDTO.GET.One {
    
    func toDomain() -> MediaResponse.GET.One {
        return .init(status: status,
                     data: data.toDomain())
    }
    
    func toEntity(in context: NSManagedObjectContext) -> MediaResponseEntity {
        let entity: MediaResponseEntity = .init(context: context)
        entity.id = data.id
      entity.type = data.type.rawValue
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

extension MediaResponseDTO.GET.Many {
    func toDomain() -> MediaResponse.GET.Many {
        return .init(status: status,
                     results: results,
                     data: data.map { $0.toDomain() })
    }
}

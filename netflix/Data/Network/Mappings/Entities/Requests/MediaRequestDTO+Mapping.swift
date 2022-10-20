//
//  MediaRequestDTO+Mapping.swift
//  netflix
//
//  Created by Zach Bazov on 16/10/2022.
//

import Foundation
import CoreData

// MARK: - MediaRequestDTO struct

struct MediaRequestDTO: Decodable {
    var user: UserDTO? = nil
    let id: String?
    let slug: String?
}

// MARK: - Mapping

extension MediaRequestDTO {
    func toEntity(in context: NSManagedObjectContext) -> MediaRequestEntity {
        let entity: MediaRequestEntity = .init(context: context)
        entity.user = user
        entity.identifier = id
        entity.slug = slug
        return entity
    }
}

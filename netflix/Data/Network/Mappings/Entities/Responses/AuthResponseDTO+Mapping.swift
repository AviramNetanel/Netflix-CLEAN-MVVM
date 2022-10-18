//
//  AuthResponseDTO+Mapping.swift
//  netflix
//
//  Created by Zach Bazov on 01/09/2022.
//

import Foundation
import CoreData

// MARK: - AuthResponseDTO struct

struct AuthResponseDTO: Decodable {
    var status: String?
    let token: String
    let data: UserDTO?
}

// MARK: - Mapping

extension AuthResponseDTO {
    func toDomain() -> AuthResponse {
        return .init(status: status,
                     token: token,
                     data: data?.toDomain())
    }
}

extension AuthResponseDTO {
    func toEntity(in context: NSManagedObjectContext) -> AuthResponseEntity? {
        guard let data = data else { return nil }
        let entity: AuthResponseEntity = .init(context: context)
        entity.token = token
        entity.data = data
        return entity
    }
}

//
//  AuthResponseEntity+Mapping.swift
//  netflix
//
//  Created by Zach Bazov on 01/09/2022.
//

import CoreData

// MARK: - AuthResponseEntity + Mapping

extension AuthResponseEntity {
    func toDTO() -> AuthResponseDTO? {
        guard let token = token else { return nil }
        return .init(token: token, data: data)
    }
}

// MARK: - AuthRequestDTO + Mapping

extension AuthRequestDTO {
    func toEntity(in context: NSManagedObjectContext) -> AuthRequestEntity {
        let entity: AuthRequestEntity = .init(context: context)
        entity.user?.name = user.name
        entity.user?.email = user.email
        entity.user?.password = user.password
        entity.user?.passwordConfirm = user.passwordConfirm
        entity.user?.role = user.role
        entity.user?.active = user.active
        return entity
    }
}

// MARK: - AuthResponseDTO + Mapping

extension AuthResponseDTO {
    func toEntity(in context: NSManagedObjectContext) -> AuthResponseEntity {
        let entity: AuthResponseEntity = .init(context: context)
        entity.token = token
        entity.data = data
        return entity
    }
}

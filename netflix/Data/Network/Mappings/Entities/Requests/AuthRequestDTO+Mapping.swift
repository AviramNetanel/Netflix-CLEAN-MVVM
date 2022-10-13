//
//  AuthRequestDTO+Mapping.swift
//  netflix
//
//  Created by Zach Bazov on 01/09/2022.
//

import Foundation

// MARK: - AuthRequestDTO struct

struct AuthRequestDTO: Decodable {
    let user: UserDTO
}

// MARK: - Mapping

extension AuthRequestDTO {
    func toDomain() -> AuthRequest {
        return .init(user: user.toDomain())
    }
}

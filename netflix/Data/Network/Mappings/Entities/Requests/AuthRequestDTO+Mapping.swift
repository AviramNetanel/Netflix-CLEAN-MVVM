//
//  AuthRequestDTO+Mapping.swift
//  netflix
//
//  Created by Zach Bazov on 01/09/2022.
//

import Foundation

struct AuthRequestDTO: Decodable {
    let user: UserDTO
}

extension AuthRequestDTO {
    func toDomain() -> AuthRequest {
        return .init(user: user.toDomain())
    }
}

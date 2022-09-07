//
//  AuthResponseDTO.swift
//  netflix
//
//  Created by Zach Bazov on 01/09/2022.
//

import Foundation
import CoreData

// MARK: - AuthResponseDTO struct

struct AuthResponseDTO: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case status
        case token
        case data
    }
    
    var status: String?
    let token: String
    var data: UserDTO?
    
    init(token: String, data: UserDTO?) {
        self.token = token
        self.data = data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let status = try container.decode(String.self, forKey: .status)
        let token = try container.decode(String.self, forKey: .token)
        let data = try container.decode(UserDTO.self, forKey: .data)
        
        self.status = status
        self.token = token
        self.data = data
    }
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

//
//  MyListRequestDTO+Mapping.swift
//  netflix
//
//  Created by Zach Bazov on 20/10/2022.
//

import Foundation

// MARK: - MyListRequestDTO struct

struct MyListRequestDTO {
    
    struct GET: Decodable {
        let user: UserDTO
        var media: [MediaDTO]?
    }
    
    struct PATCH: Decodable {
        let user: String
        let media: [String]
    }
}

// MARK: - Mapping

extension MyListRequestDTO.GET {
    func toDomain() -> MyListRequest.GET {
        return .init(user: user.toDomain())
    }
}

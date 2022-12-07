//
//  ListRequestDTO+Mapping.swift
//  netflix
//
//  Created by Zach Bazov on 20/10/2022.
//

import Foundation

struct ListRequestDTO {
    struct GET: Decodable {
        let user: UserDTO
        var media: [MediaDTO]?
    }
    
    struct PATCH: Decodable {
        let user: String
        let media: [String]
    }
    
    struct POST: Decodable {
        let user: String
        let media: [String]
    }
}

extension ListRequestDTO.GET {
    func toDomain() -> ListRequest.GET {
        return .init(user: user.toDomain())
    }
}

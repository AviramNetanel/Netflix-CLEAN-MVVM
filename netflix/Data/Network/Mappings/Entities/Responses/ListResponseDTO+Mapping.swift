//
//  ListResponseDTO+Mapping.swift
//  netflix
//
//  Created by Zach Bazov on 20/10/2022.
//

import Foundation

// MARK: - ListResponseDTO struct

struct ListResponseDTO {
    
    struct GET: Decodable {
        let status: String
        let data: ListDTO
    }
    
    struct POST: Decodable {
        let status: String
        var data: ListDTO
    }
    
    struct PATCH: Decodable {
        let status: String
        var data: ListDTO
    }
}

// MARK: - Mapping

extension ListResponseDTO.GET {
    
    func toDomain() -> ListResponse.GET {
        return .init(status: status, data: data.toDomain())
    }
}

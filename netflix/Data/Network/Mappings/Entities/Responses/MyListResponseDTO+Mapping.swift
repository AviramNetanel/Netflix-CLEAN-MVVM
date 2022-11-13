//
//  MyListResponseDTO+Mapping.swift
//  netflix
//
//  Created by Zach Bazov on 20/10/2022.
//

import Foundation

// MARK: - MyListResponseDTO struct

struct MyListResponseDTO {
    
    struct GET: Decodable {
        let status: String
        let data: MyListDTO
    }
    
    struct POST: Decodable {
        let status: String
        var data: MyListDTO
    }
    
    struct PATCH: Decodable {
        let status: String
        var data: MyListDTO
    }
}

// MARK: - Mapping

extension MyListResponseDTO.GET {
    
    func toDomain() -> MyListResponse.GET {
        return .init(status: status, data: data.toDomain())
    }
}

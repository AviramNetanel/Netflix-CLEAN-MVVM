//
//  SeasonResponseDTO+Mapping.swift
//  netflix
//
//  Created by Zach Bazov on 11/10/2022.
//

import Foundation

struct SeasonResponseDTO {
    struct GET: Decodable {
        let status: String
        let data: SeasonDTO
    }
}

extension SeasonResponseDTO.GET {
    func toDomain() -> SeasonResponse.GET {
        return .init(status: status,
                     data: data.toDomain())
    }
}

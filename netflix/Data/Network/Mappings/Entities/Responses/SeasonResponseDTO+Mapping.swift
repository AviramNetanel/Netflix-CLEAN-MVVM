//
//  SeasonResponseDTO+Mapping.swift
//  netflix
//
//  Created by Zach Bazov on 11/10/2022.
//

import Foundation

// MARK: - SeasonResponseDTO struct

struct SeasonResponseDTO: Decodable {
    let status: String
    let data: SeasonDTO
}

// MARK: - Mapping

extension SeasonResponseDTO {
    func toDomain() -> SeasonResponse {
        return .init(status: status,
                     data: data.toDomain())
    }
}

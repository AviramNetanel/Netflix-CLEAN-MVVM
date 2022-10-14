//
//  SeasonRequestDTO+Mapping.swift
//  netflix
//
//  Created by Zach Bazov on 11/10/2022.
//

import Foundation

// MARK: - SeasonRequestDTO struct

struct SeasonRequestDTO: Decodable {}

// MARK: - Mapping

extension SeasonRequestDTO {
    func toDomain() -> SeasonRequest {
        return .init()
    }
}

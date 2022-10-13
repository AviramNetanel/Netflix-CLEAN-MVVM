//
//  SectionsRequestDTO+Mapping.swift
//  netflix
//
//  Created by Zach Bazov on 07/09/2022.
//

import Foundation

// MARK: - SectionsRequestDTO struct

struct SectionsRequestDTO: Decodable {}

// MARK: - Mapping

extension SectionsRequestDTO {
    func toDomain() -> SectionsRequest {
        return .init()
    }
}

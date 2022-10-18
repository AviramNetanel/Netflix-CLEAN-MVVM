//
//  SectionResponseDTO+Mapping.swift
//  netflix
//
//  Created by Zach Bazov on 18/10/2022.
//

import Foundation

// MARK: - SectionResponseDTO + Decodable

struct SectionResponseDTO: Decodable {
    let status: String
    let data: SectionDTO
}

// MARK: - Mapping

extension SectionResponseDTO {
    func toDomain() -> SectionResponse {
        return .init(status: status,
                     data: data.toDomain())
    }
}

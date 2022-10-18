//
//  MediaResponseDTO+Mapping.swift
//  netflix
//
//  Created by Zach Bazov on 18/10/2022.
//

import Foundation

// MARK: - MediaResponseDTO struct

struct MediaResponseDTO: Decodable {
    let status: String
    let data: MediaDTO
}

// MARK: - Mapping

extension MediaResponseDTO {
    func toDomain() -> MediaResponse {
        return .init(status: status,
                     data: data.toDomain())
    }
}

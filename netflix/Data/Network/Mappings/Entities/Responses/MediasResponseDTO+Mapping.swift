//
//  MediasResponseDTO+Mapping.swift
//  netflix
//
//  Created by Zach Bazov on 16/10/2022.
//

import Foundation

// MARK: - MediasResponseDTO struct

struct MediasResponseDTO: Decodable {
    let status: String
    let results: Int
    let data: [MediaDTO]
}

// MARK: - Mapping

extension MediasResponseDTO {
    func toDomain() -> MediasResponse {
        return .init(status: status,
                     results: results,
                     data: data.map { $0.toDomain() })
    }
}

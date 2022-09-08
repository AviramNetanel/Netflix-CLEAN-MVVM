//
//  TVShowsResponseDTO.swift
//  netflix
//
//  Created by Zach Bazov on 07/09/2022.
//

import Foundation

// MARK: - TVShowsResponseDTO struct

struct TVShowsResponseDTO: Decodable {
    let status: String
    let results: Int
    let data: [MediaDTO]
}

// MARK: - Mapping

extension TVShowsResponseDTO {
    func toDomain() -> TVShowsResponse {
        return .init(status: status,
                     results: results,
                     data: data.map { $0.toDomain() })
    }
}

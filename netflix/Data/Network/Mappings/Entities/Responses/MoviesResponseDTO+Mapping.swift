//
//  MoviesResponseDTO.swift
//  netflix
//
//  Created by Zach Bazov on 07/09/2022.
//

import Foundation

// MARK: - MoviesResponseDTO struct

struct MoviesResponseDTO: Decodable {
    let status: String
    let results: Int
    let data: [MediaDTO]
}

// MARK: - Mapping

extension MoviesResponseDTO {
    func toDomain() -> MoviesResponse {
        return .init(status: status,
                     results: results,
                     data: data.map { $0.toDomain() })
    }
}

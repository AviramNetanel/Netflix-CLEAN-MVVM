//
//  MoviesRequestDTO.swift
//  netflix
//
//  Created by Zach Bazov on 07/09/2022.
//

import Foundation

// MARK: - MoviesRequestDTO struct

struct MoviesRequestDTO: Decodable {}

// MARK: - Mapping

extension MoviesRequestDTO {
    func toDomain() -> MoviesRequest {
        return .init()
    }
}

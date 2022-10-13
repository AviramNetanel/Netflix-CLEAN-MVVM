//
//  TVShowsRequestDTO+Mapping.swift
//  netflix
//
//  Created by Zach Bazov on 06/09/2022.
//

import Foundation

// MARK: - TVShowsRequestDTO struct

struct TVShowsRequestDTO: Decodable {}

// MARK: - Mapping

extension TVShowsRequestDTO {
    func toDomain() -> TVShowsRequest {
        return .init()
    }
}

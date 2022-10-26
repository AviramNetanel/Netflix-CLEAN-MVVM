//
//  SeasonRequestDTO+Mapping.swift
//  netflix
//
//  Created by Zach Bazov on 11/10/2022.
//

import Foundation

// MARK: - SeasonRequestDTO struct

struct SeasonRequestDTO {
    
    struct GET: Decodable {
        var id: String? = nil
        var slug: String? = nil
        var season: Int? = 1
    }
}

// MARK: - Mapping

extension SeasonRequestDTO.GET {
    func toDomain() -> SeasonRequest.GET {
        return .init()
    }
}

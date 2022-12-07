//
//  SectionResponseDTO+Mapping.swift
//  netflix
//
//  Created by Zach Bazov on 07/09/2022.
//

import Foundation

struct SectionResponseDTO {
    struct GET: Decodable {
        let status: String
        let results: Int
        let data: [SectionDTO]
    }
}

extension SectionResponseDTO.GET {
    func toDomain() -> SectionResponse.GET {
        return .init(status: status,
                     results: results,
                     data: data.map { $0.toDomain() })
    }
}

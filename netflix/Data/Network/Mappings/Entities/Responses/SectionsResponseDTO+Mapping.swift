//
//  SectionsResponseDTO.swift
//  netflix
//
//  Created by Zach Bazov on 07/09/2022.
//

import Foundation

// MARK: - SectionsResponseDTO struct

struct SectionsResponseDTO: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case status
        case results
        case data
    }
    
    let status: String
    let results: Int
    let data: [SectionDTO]
    
//    init(token: String, data: UserDTO?) {
//        self.token = token
//        self.data = data
//    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let status = try container.decode(String.self, forKey: .status)
        let results = try container.decode(Int.self, forKey: .results)
        let data = try container.decode([SectionDTO].self, forKey: .data)
        
        self.status = status
        self.results = results
        self.data = data
    }
}

// MARK: - Mapping

extension SectionsResponseDTO {
    func toDomain() -> SectionsResponse {
        return .init(status: status,
                     results: results,
                     data: data.map { $0.toDomain() })
    }
}

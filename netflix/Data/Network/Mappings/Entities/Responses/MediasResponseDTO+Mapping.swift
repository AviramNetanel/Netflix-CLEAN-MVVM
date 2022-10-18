//
//  MediasResponseDTO+Mapping.swift
//  netflix
//
//  Created by Zach Bazov on 16/10/2022.
//

import Foundation

// MARK: - MediasResponseDTO struct

struct MediasResponseDTO: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case status
        case results
        case data
    }
    
    let status: String
    let results: Int
    let data: [MediaDTO]
    
    init(status: String,
         results: Int,
         data: [MediaDTO]) {
        self.status = status
        self.results = results
        self.data = data
    }
}

// MARK: - Mapping

extension MediasResponseDTO {
    func toDomain() -> MediasResponse {
        return .init(status: status,
                     results: results,
                     data: data.map { $0.toDomain() })
    }
}



// MARK: - MediaResponseDTO struct

struct MediaResponseDTO: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case status
        case data
    }
    
    let status: String
    let data: MediaDTO
    
    init(status: String,
         data: MediaDTO) {
        self.status = status
        self.data = data
    }
}

// MARK: - Mapping

extension MediaResponseDTO {
    func toDomain() -> MediaResponse {
        return .init(status: status,
                     data: data.toDomain())
    }
}

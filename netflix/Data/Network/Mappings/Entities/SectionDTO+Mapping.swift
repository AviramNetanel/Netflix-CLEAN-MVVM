//
//  SectionDTO+DataMapping.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import Foundation

// MARK: - SectionDTO struct

struct SectionDTO: Decodable {
    let id: Int
    let title: String
    var tvshows: [MediaDTO]
    var movies: [MediaDTO]
}

// MARK: - DataMapping

extension SectionDTO {
    func toDomain() -> Section {
        return .init(id: id,
                     title: title,
                     tvshows: tvshows.map { $0.toDomain() },
                     movies: movies.map { $0.toDomain() })
    }
}

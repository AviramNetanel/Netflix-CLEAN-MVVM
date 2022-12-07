//
//  SectionDTO+Mapping.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import Foundation

struct SectionDTO: Decodable {
    let id: Int
    let title: String
    var media: [MediaDTO]
}

extension SectionDTO {
    func toDomain() -> Section {
        return .init(id: id,
                     title: title,
                     media: media.map { $0.toDomain() })
    }
}

//
//  ListDTO+Mapping.swift
//  netflix
//
//  Created by Zach Bazov on 20/10/2022.
//

import Foundation

struct ListDTO: Decodable {
    let user: String
    var media: [MediaDTO]
}

extension ListDTO {
    func toDomain() -> List {
        return .init(user: user,
                     media: media.map { $0.toDomain() })
    }
}

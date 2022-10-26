//
//  MyListDTO+Mapping.swift
//  netflix
//
//  Created by Zach Bazov on 20/10/2022.
//

import Foundation

// MARK: - MyListDTO struct

struct MyListDTO: Decodable {
    let user: String
    var media: [MediaDTO]
}

// MARK: - Mapping

extension MyListDTO {
    func toDomain() -> MyList {
        return .init(user: user,
                     media: media.map { $0.toDomain() })
    }
}

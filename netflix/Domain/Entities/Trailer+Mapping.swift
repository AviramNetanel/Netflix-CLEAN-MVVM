//
//  Trailer.swift
//  netflix
//
//  Created by Zach Bazov on 12/10/2022.
//

import Foundation

// MARK: - Trailer struct

struct Trailer {
    var id: String?
    var urlPath: String
}

// MARK: - Mediable implementation

extension Trailer: Mediable {}

// MARK: - Mapping

extension Array where Element == String {
    func toDomain() -> Array<Trailer> { map { .init(urlPath: $0) } }
}

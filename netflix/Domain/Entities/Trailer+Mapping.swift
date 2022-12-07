//
//  Trailer.swift
//  netflix
//
//  Created by Zach Bazov on 12/10/2022.
//

import Foundation

struct Trailer {
    var id: String?
    var urlPath: String
}

extension Trailer: Mediable {}

extension Array where Element == String {
    func toDomain() -> Array<Trailer> { map { .init(urlPath: $0) } }
}

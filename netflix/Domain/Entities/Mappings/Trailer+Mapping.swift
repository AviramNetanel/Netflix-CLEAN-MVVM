//
//  Trailer+Mapping.swift
//  netflix
//
//  Created by Zach Bazov on 12/10/2022.
//

import Foundation

// MARK: - Trailer + Mapping

extension Array where Element == String {
    func toDomain() -> Array<Trailer> { map { .init(urlPath: $0) } }
}

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

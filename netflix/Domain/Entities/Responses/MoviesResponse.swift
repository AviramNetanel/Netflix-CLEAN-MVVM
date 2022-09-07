//
//  MoviesResponse.swift
//  netflix
//
//  Created by Zach Bazov on 08/09/2022.
//

import Foundation

// MARK: - MoviesResponse struct

struct MoviesResponse {
    let status: String
    let results: Int
    let data: [Media]
}

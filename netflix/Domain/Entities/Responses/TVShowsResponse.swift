//
//  TVShowsResponse.swift
//  netflix
//
//  Created by Zach Bazov on 08/09/2022.
//

import Foundation

// MARK: - TVShowsResponse struct

struct TVShowsResponse {
    let status: String
    let results: Int
    let data: [Media]
}

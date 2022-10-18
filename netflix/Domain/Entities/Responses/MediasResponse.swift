//
//  MediasResponse.swift
//  netflix
//
//  Created by Zach Bazov on 16/10/2022.
//

import Foundation

// MARK: - MediasResponse struct

struct MediasResponse {
    let status: String
    let results: Int
    let data: [Media]
}


struct MediaResponse {
    let status: String
    let data: Media
}

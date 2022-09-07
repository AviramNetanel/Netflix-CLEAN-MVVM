//
//  TVShowsResponseDTO.swift
//  netflix
//
//  Created by Zach Bazov on 07/09/2022.
//

import Foundation

// MARK: - TVShowsResponseDTO struct

struct TVShowsResponseDTO: Decodable {
    let status: String
    let results: Int
    let data: [MediaDTO]
}

struct RepoResponseDTO: Decodable {
    let status: String
    let results: Int
    let data: [MediaDTO]
}

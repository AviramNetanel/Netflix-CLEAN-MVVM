//
//  MoviesResponseDTO.swift
//  netflix
//
//  Created by Zach Bazov on 07/09/2022.
//

import Foundation

// MARK: - MoviesResponseDTO struct

struct MoviesResponseDTO: Decodable {
    let status: String
    let results: Int
    let data: [MediaDTO]
}

//
//  TVShowsRequestDTO.swift
//  netflix
//
//  Created by Zach Bazov on 06/09/2022.
//

import Foundation

struct TVShowsRequestDTO: Decodable {
    
}

struct TVShowsResponseDTO: Decodable {
    let status: String
    let results: Int
    let data: [MediaDTO]
}

struct MoviesRequestDTO: Decodable {
    
}

struct MoviesResponseDTO: Decodable {
    let status: String
    let results: Int
    let data: [MediaDTO]
}

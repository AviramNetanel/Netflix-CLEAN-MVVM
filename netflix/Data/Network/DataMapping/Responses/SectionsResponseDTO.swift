//
//  SectionsResponseDTO.swift
//  netflix
//
//  Created by Zach Bazov on 07/09/2022.
//

import Foundation

// MARK: - SectionsResponseDTO struct

struct SectionsResponseDTO: Decodable {
    let status: String
    let results: Int
    let data: [SectionDTO]
}

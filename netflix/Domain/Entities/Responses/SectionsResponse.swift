//
//  SectionsResponse.swift
//  netflix
//
//  Created by Zach Bazov on 08/09/2022.
//

import Foundation

// MARK: - SectionsResponse struct

struct SectionsResponse {
    let status: String
    let results: Int
    let data: [Section]
}

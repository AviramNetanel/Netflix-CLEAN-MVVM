//
//  SeasonResponse.swift
//  netflix
//
//  Created by Zach Bazov on 11/10/2022.
//

import Foundation

// MARK: - SeasonResponse struct

struct SeasonResponse {
    
    struct GET {
        let status: String
        let data: Season
    }
}

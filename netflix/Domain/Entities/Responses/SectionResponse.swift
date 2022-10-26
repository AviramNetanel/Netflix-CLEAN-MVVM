//
//  SectionResponse.swift
//  netflix
//
//  Created by Zach Bazov on 08/09/2022.
//

import Foundation

// MARK: - SectionResponse struct

struct SectionResponse {
    
    struct GET {
        let status: String
        let results: Int
        let data: [Section]
    }
}

//
//  ListResponse.swift
//  netflix
//
//  Created by Zach Bazov on 20/10/2022.
//

import Foundation

// MARK: - ListResponse struct

struct ListResponse {
    
    struct GET {
        let status: String
        let data: List
    }
}

//
//  MyListResponse.swift
//  netflix
//
//  Created by Zach Bazov on 20/10/2022.
//

import Foundation

// MARK: - MyListResponse struct

struct MyListResponse {
    
    struct GET {
        let status: String
        let data: MyList
    }
}

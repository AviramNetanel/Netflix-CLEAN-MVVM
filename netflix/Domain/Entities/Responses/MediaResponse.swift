//
//  MediaResponse.swift
//  netflix
//
//  Created by Zach Bazov on 16/10/2022.
//

import Foundation

struct MediaResponse {
    struct GET {
        struct One {
            let status: String
            let data: Media
        }
        
        struct Many {
            let status: String
            let results: Int
            let data: [Media]
        }
    }
}

//
//  MediaRequestQuery.swift
//  netflix
//
//  Created by Zach Bazov on 20/10/2022.
//

import Foundation

// MARK: - MediaRequestQuery struct

struct MediaRequestQuery {
    var user: UserDTO? = nil
    let media: MediaRequestDTO
}

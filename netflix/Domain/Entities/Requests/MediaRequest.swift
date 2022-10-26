//
//  MediaRequest.swift
//  netflix
//
//  Created by Zach Bazov on 16/10/2022.
//

import Foundation

// MARK: - MediaRequest struct

struct MediaRequest {
    var user: UserDTO? = nil
    let media: MediaRequestDTO
}

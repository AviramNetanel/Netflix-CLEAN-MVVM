//
//  AuthRequestDTO.swift
//  netflix
//
//  Created by Zach Bazov on 01/09/2022.
//

import Foundation

// MARK: - AuthRequestDTO struct

struct AuthRequestDTO: Decodable {
    var user: UserDTO
}

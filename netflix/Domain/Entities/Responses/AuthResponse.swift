//
//  AuthResponse.swift
//  netflix
//
//  Created by Zach Bazov on 08/09/2022.
//

import Foundation

// MARK: - AuthResponse struct

struct AuthResponse {
    var status: String?
    let token: String
    var data: User?
}

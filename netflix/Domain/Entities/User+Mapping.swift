//
//  User.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import Foundation

// MARK: - User struct

struct User {
    let _id: String?
    let name: String?
    let email: String?
    let password: String?
    let passwordConfirm: String?
    let role: String?
    let active: Bool?
    var token: String?
}

// MARK: - Mapping

extension User {
    func toDTO() -> UserDTO {
        return .init(_id: _id,
                     name: name,
                     email: email,
                     password: password,
                     passwordConfirm: passwordConfirm,
                     role: role,
                     active: active,
                     token: token)
    }
}

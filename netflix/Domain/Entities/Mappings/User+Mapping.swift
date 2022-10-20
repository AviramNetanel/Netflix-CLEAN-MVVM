//
//  User+Mapping.swift
//  netflix
//
//  Created by Zach Bazov on 20/10/2022.
//

import Foundation

// MARK: - User + Mapping

extension User {
    func toDTO() -> UserDTO {
        return .init(name: name,
                     email: email,
                     password: password,
                     passwordConfirm: passwordConfirm,
                     role: role,
                     active: active)
    }
}

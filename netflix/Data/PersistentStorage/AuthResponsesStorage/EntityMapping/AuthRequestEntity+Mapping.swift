//
//  AuthRequestEntity+Mapping.swift
//  netflix
//
//  Created by Zach Bazov on 20/10/2022.
//

import Foundation

// MARK: - AuthRequestEntity + Mapping

extension AuthRequestEntity {
    func toDTO() -> AuthRequestDTO {
        let userDTO = UserDTO(name: user!.name,
                              email: user!.email,
                              password: user!.password,
                              passwordConfirm: user!.passwordConfirm,
                              role: user!.role,
                              active: user!.active)
        return .init(user: userDTO)
    }
}

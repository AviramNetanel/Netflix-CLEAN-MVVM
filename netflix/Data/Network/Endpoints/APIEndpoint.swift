//
//  APIEndpoint.swift
//  netflix
//
//  Created by Zach Bazov on 01/09/2022.
//

import Foundation

// MARK: - APIEndpoint struct

struct APIEndpoint {
    
    static func signUp(with authRequestDTO: AuthRequestDTO) -> Endpoint<AuthResponseDTO> {
        return Endpoint(path: "api/v1/users/signup",
                        method: .post)
    }
    
    static func signIn(with authRequestDTO: AuthRequestDTO) -> Endpoint<AuthResponseDTO> {
        return Endpoint(path: "api/v1/users/signin",
                        method: .post,
                        bodyParameters: ["email": authRequestDTO.user.email!,
                                         "password": authRequestDTO.user.password!],
                        bodyEncoding: .jsonSerializationData)
    }
}

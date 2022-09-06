//
//  AuthRepository.swift
//  netflix
//
//  Created by Zach Bazov on 01/09/2022.
//

import Foundation

// MARK: - AuthRepository protocol

protocol AuthRepository {
    
    func signUp(query: AuthQuery,
                cached: @escaping (AuthResponseDTO?) -> Void,
                completion: @escaping (Result<AuthResponseDTO, Error>) -> Void) -> Cancellable?
    
    func signIn(query: AuthQuery,
                cached: @escaping (AuthResponseDTO?) -> Void,
                completion: @escaping (Result<AuthResponseDTO, Error>) -> Void) -> Cancellable?
}

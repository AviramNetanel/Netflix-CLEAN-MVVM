//
//  AuthUseCase.swift
//  netflix
//
//  Created by Zach Bazov on 01/09/2022.
//

import Foundation

// MARK: - AuthUseCase protocol

protocol AuthUseCase {
    func execute(requestValue: AuthUseCaseRequestValue,
                 cached: @escaping (User?) -> Void,
                 completion: @escaping (Result<AuthResponseDTO, Error>) -> Void) -> Cancellable?
}

// MARK: - DefaultAuthUseCase class

final class DefaultAuthUseCase: AuthUseCase {
    
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(requestValue: AuthUseCaseRequestValue,
                 cached: @escaping (User?) -> Void,
                 completion: @escaping (Result<AuthResponseDTO, Error>) -> Void) -> Cancellable? {
        return requestValue.method == .signin
            ? createSignInRequest(with: requestValue, cached: cached, completion: completion)
            : createSignUpRequest(with: requestValue, cached: cached, completion: completion)
    }
    
    // MARK: Private
    
    private func createSignUpRequest(with requestValue: AuthUseCaseRequestValue,
                                     cached: @escaping (User?) -> Void,
                                     completion: @escaping (Result<AuthResponseDTO, Error>) -> Void) -> Cancellable? {
        return authRepository.signUp(query: requestValue.query,
                                     cached: cached) { result in
           switch result {
           case .success(let response):
               completion(.success(response))
           case .failure(let error):
               completion(.failure(error))
           }
       }
    }
    
    private func createSignInRequest(with requestValue: AuthUseCaseRequestValue,
                                     cached: @escaping (User?) -> Void,
                                     completion: @escaping (Result<AuthResponseDTO, Error>) -> Void) -> Cancellable? {
        return authRepository.signIn(query: requestValue.query,
                                     cached: cached) { result in
            switch result {
            case .success(let response):
                cached(requestValue.query.user.toDomain())
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - AuthUseCaseRequestValue struct

struct AuthUseCaseRequestValue {
    let method: AuthMethod
    let query: AuthQuery
}

// MARK: - AuthMethod struct

enum AuthMethod {
    case signup
    case signin
}

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
                 cached: @escaping (AuthResponseDTO?) -> Void,
                 completion: @escaping (Result<AuthResponseDTO, Error>) -> Void) -> Cancellable?
}

// MARK: - DefaultAuthUseCase class

final class DefaultAuthUseCase: AuthUseCase {
    
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(requestValue: AuthUseCaseRequestValue,
                 cached: @escaping (AuthResponseDTO?) -> Void,
                 completion: @escaping (Result<AuthResponseDTO, Error>) -> Void) -> Cancellable? {
        return request(requestValue: requestValue, cached: cached, completion: completion)
    }
    
    // MARK: Private
    
    private func request(requestValue: AuthUseCaseRequestValue,
                         cached: @escaping (AuthResponseDTO?) -> Void,
                         completion: @escaping (Result<AuthResponseDTO, Error>) -> Void) -> Cancellable? {
        switch requestValue.method {
        case .signup:
            return authRepository.signUp(query: requestValue.query,
                                         cached: cached) { result in
                switch result {
                case .success(let response):
                    completion(.success(response))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        case .signin:
            return authRepository.signIn(query: requestValue.query,
                                         cached: cached) { result in
                switch result {
                case .success(let response):
                    cached(response)
                    completion(.success(response))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}

// MARK: - AuthUseCaseRequestValue struct

struct AuthUseCaseRequestValue {
    var method: AuthMethod
    let query: AuthQuery
}

// MARK: - AuthMethod struct

enum AuthMethod {
    case signup
    case signin
}

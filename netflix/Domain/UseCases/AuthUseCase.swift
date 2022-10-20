//
//  AuthUseCase.swift
//  netflix
//
//  Created by Zach Bazov on 01/09/2022.
//

import Foundation

// MARK: - AuthUseCaseRequestValue struct

struct AuthUseCaseRequestValue {
    var method: AuthMethod
    let query: AuthRequestQuery
}

// MARK: - AuthMethod struct

enum AuthMethod {
    case signup
    case signin
}

// MARK: - UseCaseInput protocol

private protocol UseCaseInput {
    func execute(requestValue: AuthUseCaseRequestValue,
                 cached: @escaping (AuthResponseDTO?) -> Void,
                 completion: @escaping (Result<AuthResponseDTO, Error>) -> Void) -> Cancellable?
}

// MARK: - UseCaseOutput protocol

private protocol UseCaseOutput {
    var authRepository: AuthRepository { get }
}

// MARK: - UseCase typealias

private typealias UseCase = UseCaseInput & UseCaseOutput

// MARK: - AuthUseCase class

final class AuthUseCase: UseCase {
    
    let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
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
    
    func execute(requestValue: AuthUseCaseRequestValue,
                 cached: @escaping (AuthResponseDTO?) -> Void,
                 completion: @escaping (Result<AuthResponseDTO, Error>) -> Void) -> Cancellable? {
        return request(requestValue: requestValue,
                       cached: cached,
                       completion: completion)
    }
}

//
//  AuthUseCase.swift
//  netflix
//
//  Created by Zach Bazov on 01/09/2022.
//

import Foundation

struct AuthUseCaseRequestValue {
    var method: AuthMethod
    let request: AuthRequest
}

enum AuthMethod {
    case signup
    case signin
}

private protocol UseCaseInput {
    func execute(requestValue: AuthUseCaseRequestValue,
                 cached: @escaping (AuthResponseDTO?) -> Void,
                 completion: @escaping (Result<AuthResponseDTO, Error>) -> Void) -> Cancellable?
}

private protocol UseCaseOutput {
    var authRepository: AuthRepository { get }
}

private typealias UseCase = UseCaseInput & UseCaseOutput

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
            return authRepository.signUp(request: requestValue.request,
                                         cached: cached) { result in
                switch result {
                case .success(let response):
                    completion(.success(response))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        case .signin:
            return authRepository.signIn(request: requestValue.request,
                                         cached: cached) { result in
                switch result {
                case .success(let response):
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

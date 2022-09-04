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
        return authRepository.signIn(query: requestValue.query,
                                     cached: cached,
                                     completion: { result in
            switch result {
            case .success(let response):
                cached(requestValue.query.user.toDomain())
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}

// MARK: - AuthUseCaseRequestValue struct

struct AuthUseCaseRequestValue {
    let query: AuthQuery
}

//
//  AuthRepository.swift
//  netflix
//
//  Created by Zach Bazov on 05/09/2022.
//

import Foundation

// MARK: - RepositoryInput protocol

private protocol RepositoryInput {
    func signUp(query: AuthRequestQuery,
                cached: @escaping (AuthResponseDTO?) -> Void,
                completion: @escaping (Result<AuthResponseDTO, Error>) -> Void) -> Cancellable?
    
    func signIn(query: AuthRequestQuery,
                cached: @escaping (AuthResponseDTO?) -> Void,
                completion: @escaping (Result<AuthResponseDTO, Error>) -> Void) -> Cancellable?
}

// MARK: - RepositoryOutput protocol

private protocol RepositoryOutput {
    var dataTransferService: DataTransferService { get }
    var cache: AuthResponseStorage { get }
}

// MARK: - Repository typealias

private typealias Repository = RepositoryInput & RepositoryOutput

// MARK: - AuthRepository class

final class AuthRepository {
    
    private let dataTransferService: DataTransferService
    let cache: AuthResponseStorage
    
    init(dataTransferService: DataTransferService,
         cache: AuthResponseStorage) {
        self.dataTransferService = dataTransferService
        self.cache = cache
    }
}

// MARK: - RepositoryInput implementation

extension AuthRepository: RepositoryInput {
    
    func signUp(query: AuthRequestQuery,
                cached: @escaping (AuthResponseDTO?) -> Void,
                completion: @escaping (Result<AuthResponseDTO, Error>) -> Void) -> Cancellable? {
        
        let requestDTO = AuthRequestDTO(user: query.user)
        let task = RepositoryTask()
        
        guard !task.isCancelled else { return nil }
        
        let endpoint = APIEndpoint.signUp(with: requestDTO)
        task.networkTask = dataTransferService.request(with: endpoint) { result in
            switch result {
            case .success(let response):
                self.cache.save(response: response, for: requestDTO)
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        return task
    }
    
    func signIn(query: AuthRequestQuery,
                cached: @escaping (AuthResponseDTO?) -> Void,
                completion: @escaping (Result<AuthResponseDTO, Error>) -> Void) -> Cancellable? {
        
        let requestDTO = AuthRequestDTO(user: query.user)
        let task = RepositoryTask()
        
        cache.getResponse(for: requestDTO) { result in
            if case let .success(responseDTO?) = result {
                return cached(responseDTO)
            }
            
            guard !task.isCancelled else { return }
            
            let endpoint = APIEndpoint.signIn(with: requestDTO)
            task.networkTask = self.dataTransferService.request(with: endpoint) { result in
                switch result {
                case .success(let response):
                    self.cache.save(response: response, for: requestDTO)
                    completion(.success(response))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
        return task
    }
}

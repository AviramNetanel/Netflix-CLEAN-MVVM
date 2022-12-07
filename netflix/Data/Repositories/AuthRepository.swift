//
//  AuthRepository.swift
//  netflix
//
//  Created by Zach Bazov on 05/09/2022.
//

import Foundation

private protocol RepositoryInput {
    func signUp(request: AuthRequest,
                cached: @escaping (AuthResponseDTO?) -> Void,
                completion: @escaping (Result<AuthResponseDTO, Error>) -> Void) -> Cancellable?
    func signIn(request: AuthRequest,
                cached: @escaping (AuthResponseDTO?) -> Void,
                completion: @escaping (Result<AuthResponseDTO, Error>) -> Void) -> Cancellable?
}

private protocol RepositoryOutput {
    var dataTransferService: DataTransferService { get }
    var cache: AuthResponseStorage { get }
}

private typealias Repository = RepositoryInput & RepositoryOutput

final class AuthRepository {
    private let dataTransferService: DataTransferService
    let cache: AuthResponseStorage
    
    init(dataTransferService: DataTransferService,
         cache: AuthResponseStorage) {
        self.dataTransferService = dataTransferService
        self.cache = cache
    }
}

extension AuthRepository: RepositoryInput {
    func signUp(request: AuthRequest,
                cached: @escaping (AuthResponseDTO?) -> Void,
                completion: @escaping (Result<AuthResponseDTO, Error>) -> Void) -> Cancellable? {
        
        let requestDTO = AuthRequestDTO(user: request.user.toDTO())
        let task = RepositoryTask()
        
        guard !task.isCancelled else { return nil }
        
        let endpoint = APIEndpoint.AuthRepository.signUp(with: requestDTO)
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
    
    func signIn(request: AuthRequest,
                cached: @escaping (AuthResponseDTO?) -> Void,
                completion: @escaping (Result<AuthResponseDTO, Error>) -> Void) -> Cancellable? {
        
        let requestDTO = AuthRequestDTO(user: request.user.toDTO())
        let task = RepositoryTask()
        
        cache.getResponse(for: requestDTO) { result in
            if case let .success(responseDTO?) = result {
                return cached(responseDTO)
            }
            
            guard !task.isCancelled else { return }
            
            let endpoint = APIEndpoint.AuthRepository.signIn(with: requestDTO)
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

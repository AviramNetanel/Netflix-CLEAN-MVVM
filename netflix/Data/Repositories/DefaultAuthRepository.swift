//
//  DefaultAuthRepository.swift
//  netflix
//
//  Created by Zach Bazov on 05/09/2022.
//

import Foundation

// MARK: - DefaultAuthRepository class

final class DefaultAuthRepository {
    
    private let dataTransferService: DataTransferService
    private let cache: AuthResponseStorage
    
    init(dataTransferService: DataTransferService, cache: AuthResponseStorage) {
        self.dataTransferService = dataTransferService
        self.cache = cache
    }
}

// MARK: - AuthRepository implementation

extension DefaultAuthRepository: AuthRepository {
    
    func signUp(query: AuthQuery,
                cached: @escaping (AuthResponseDTO?) -> Void,
                completion: @escaping (Result<AuthResponseDTO, Error>) -> Void) -> Cancellable? {
        
        let requestDTO = AuthRequestDTO(user: query.user)
        let task = RepositoryTask()
        
        guard !task.isCancelled else { return nil }
        
        let endpoint = APIEndpoint.signUp(with: requestDTO)
        task.networkTask = self.dataTransferService.request(with: endpoint) { result in
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
    
    func signIn(query: AuthQuery,
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

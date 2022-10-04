//
//  TVShowsRepository.swift
//  netflix
//
//  Created by Zach Bazov on 06/09/2022.
//

import Foundation

// MARK: - RepositoryInput protocol

private protocol RepositoryInput {
    func getAll(completion: @escaping (Result<TVShowsResponseDTO, Error>) -> Void) -> Cancellable?
}

// MARK: - RepositoryOutput protocol

private protocol RepositoryOutput {
    var dataTransferService: DataTransferService { get }
}

// MARK: - Repository typealias

private typealias Repository = RepositoryInput & RepositoryOutput

// MARK: - TVShowsRepository class

final class TVShowsRepository: Repository {
    
    fileprivate let dataTransferService: DataTransferService
    
    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

// MARK: - RepositoryInput implementation

extension TVShowsRepository {
    
    func getAll(completion: @escaping (Result<TVShowsResponseDTO, Error>) -> Void) -> Cancellable? {
        let task = RepositoryTask()
        
        guard !task.isCancelled else { return nil }
        
        let endpoint = APIEndpoint.getTVShows()
        task.networkTask = dataTransferService.request(with: endpoint) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        return task
    }
}

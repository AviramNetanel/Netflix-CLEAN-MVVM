//
//  MediaRepository.swift
//  netflix
//
//  Created by Zach Bazov on 17/10/2022.
//

import Foundation

// MARK: - RepositoryInput protocol

private protocol RepositoryInput {
    func getAll(completion: @escaping (Result<MediasResponseDTO, Error>) -> Void) -> Cancellable?
    func getOne(query: MediaRequestQuery,
                cached: @escaping (MediaResponseDTO?) -> Void,
                completion: @escaping (Result<MediaResponseDTO, Error>) -> Void) -> Cancellable?
}

// MARK: - RepositoryOutput protocol

private protocol RepositoryOutput {
    var dataTransferService: DataTransferService { get }
    var cache: MediaResponseStorage { get }
}

// MARK: - Repository typealias

private typealias Repository = RepositoryInput & RepositoryOutput

// MARK: - MediaRepository struct

final class MediaRepository: Repository {
    
    fileprivate let dataTransferService: DataTransferService
    fileprivate let cache: MediaResponseStorage
    
    init(dataTransferService: DataTransferService,
         cache: MediaResponseStorage) {
        self.dataTransferService = dataTransferService
        self.cache = cache
    }
    
    func getAll(completion: @escaping (Result<MediasResponseDTO, Error>) -> Void) -> Cancellable? {
        let task = RepositoryTask()
        
        guard !task.isCancelled else { return nil }
        
        let endpoint = APIEndpoint.getAllMedia()
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
    
    func getOne(query: MediaRequestQuery,
                cached: @escaping (MediaResponseDTO?) -> Void,
                completion: @escaping (Result<MediaResponseDTO, Error>) -> Void) -> Cancellable? {
        
        let requestDTO = MediaRequestDTO(user: query.user,
                                         id: query.media.id,
                                         slug: query.media.slug)
        let task = RepositoryTask()
        
        guard !task.isCancelled else { return nil }
        
        let endpoint = APIEndpoint.getMedia(with: requestDTO)
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
}

//
//  MediaRepository.swift
//  netflix
//
//  Created by Zach Bazov on 17/10/2022.
//

import Foundation

// MARK: - RepositoryInput protocol

private protocol RepositoryInput {
    func getAll(completion: @escaping (Result<MediaResponseDTO.GET.Many, Error>) -> Void) -> Cancellable?
    func getOne(request: MediaRequestDTO.GET.One,
                cached: @escaping (MediaResponseDTO.GET.One?) -> Void,
                completion: @escaping (Result<MediaResponseDTO.GET.One, Error>) -> Void) -> Cancellable?
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
    
    func getAll(completion: @escaping (Result<MediaResponseDTO.GET.Many, Error>) -> Void) -> Cancellable? {
        let task = RepositoryTask()
        
        guard !task.isCancelled else { return nil }
        
        let endpoint = APIEndpoint.MediaRepository.getAllMedia()
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
    
    func getOne(request: MediaRequestDTO.GET.One,
                cached: @escaping (MediaResponseDTO.GET.One?) -> Void,
                completion: @escaping (Result<MediaResponseDTO.GET.One, Error>) -> Void) -> Cancellable? {
        let requestDTO = MediaRequestDTO.GET.One(user: request.user,
                                             id: request.id,
                                             slug: request.slug)
        let task = RepositoryTask()
        
        guard !task.isCancelled else { return nil }
        
        let endpoint = APIEndpoint.MediaRepository.getMedia(with: requestDTO)
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

//
//  ListRepository.swift
//  netflix
//
//  Created by Zach Bazov on 20/10/2022.
//

import Foundation

// MARK: - RepositoryInput protocol

private protocol RepositoryInput {
    func getAll(completion: @escaping (Result<ListResponseDTO.GET, Error>) -> Void) -> Cancellable?
    func getOne(request: ListRequestDTO.GET,
                completion: @escaping (Result<ListResponseDTO.GET, Error>) -> Void) -> Cancellable?
    func createOne(request: ListRequestDTO.POST,
                   completion: @escaping (Result<ListResponseDTO.POST, Error>) -> Void) -> Cancellable?
    func updateOne(request: ListRequestDTO.PATCH,
                   completion: @escaping (Result<ListResponseDTO.PATCH, Error>) -> Void) -> Cancellable?
}

// MARK: - RepositoryOutput protocol

private protocol RepositoryOutput {
    var dataTransferService: DataTransferService { get }
}

// MARK: - Repository typealias

private typealias Repository = RepositoryInput & RepositoryOutput

// MARK: - ListRepository struct

struct ListRepository: Repository {
    
    let dataTransferService: DataTransferService
    
    func getAll(completion: @escaping (Result<ListResponseDTO.GET, Error>) -> Void) -> Cancellable? {
        let task = RepositoryTask()
        
        guard !task.isCancelled else { return nil }
        
        let endpoint = APIEndpoint.MyListRepository.getAllMyLists()
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
    
    func getOne(request: ListRequestDTO.GET,
                completion: @escaping (Result<ListResponseDTO.GET, Error>) -> Void) -> Cancellable? {
        let requestDTO = ListRequestDTO.GET(user: request.user)
        let task = RepositoryTask()
        
        guard !task.isCancelled else { return nil }
        
        let endpoint = APIEndpoint.MyListRepository.getMyList(with: requestDTO)
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
    
    func createOne(request: ListRequestDTO.POST,
                   completion: @escaping (Result<ListResponseDTO.POST, Error>) -> Void) -> Cancellable? {
        let task = RepositoryTask()
        
        guard !task.isCancelled else { return nil }
        
        let endpoint = APIEndpoint.MyListRepository.createMyList(with: request)
        task.networkTask = dataTransferService.request(
            with: endpoint,
            completion: { result in
                switch result {
                case .success(let response):
                    completion(.success(response))
                case .failure(let error):
                    completion(.failure(error))
                }
            })
        
        return task
    }
    
    func updateOne(request: ListRequestDTO.PATCH,
                   completion: @escaping (Result<ListResponseDTO.PATCH, Error>) -> Void) -> Cancellable? {
        let task = RepositoryTask()
        
        guard !task.isCancelled else { return nil }
        
        let endpoint = APIEndpoint.MyListRepository.updateMyList(with: request)
        task.networkTask = dataTransferService.request(
            with: endpoint,
            completion: { result in
                switch result {
                case .success(let response):
                    completion(.success(response))
                case .failure(let error):
                    completion(.failure(error))
                }
            })
        
        return task
    }
}

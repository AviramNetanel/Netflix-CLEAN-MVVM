//
//  MyListRepository.swift
//  netflix
//
//  Created by Zach Bazov on 20/10/2022.
//

import Foundation

// MARK: - RepositoryInput protocol

private protocol RepositoryInput {
    func getAll(completion: @escaping (Result<MyListResponseDTO.GET, Error>) -> Void) -> Cancellable?
    func getOne(request: MyListRequestDTO.GET,
                completion: @escaping (Result<MyListResponseDTO.GET, Error>) -> Void) -> Cancellable?
    func createOne(request: MyListRequestDTO.POST,
                   completion: @escaping (Result<MyListResponseDTO.POST, Error>) -> Void) -> Cancellable?
    func updateOne(request: MyListRequestDTO.PATCH,
                   completion: @escaping (Result<MyListResponseDTO.PATCH, Error>) -> Void) -> Cancellable?
}

// MARK: - RepositoryOutput protocol

private protocol RepositoryOutput {
    var dataTransferService: DataTransferService { get }
}

// MARK: - Repository typealias

private typealias Repository = RepositoryInput & RepositoryOutput

// MARK: - MyListRepository struct

struct MyListRepository: Repository {
    
    let dataTransferService: DataTransferService
    
    func getAll(completion: @escaping (Result<MyListResponseDTO.GET, Error>) -> Void) -> Cancellable? {
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
    
    func getOne(request: MyListRequestDTO.GET,
                completion: @escaping (Result<MyListResponseDTO.GET, Error>) -> Void) -> Cancellable? {
        let requestDTO = MyListRequestDTO.GET(user: request.user)
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
    
    func createOne(request: MyListRequestDTO.POST,
                   completion: @escaping (Result<MyListResponseDTO.POST, Error>) -> Void) -> Cancellable? {
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
    
    func updateOne(request: MyListRequestDTO.PATCH,
                   completion: @escaping (Result<MyListResponseDTO.PATCH, Error>) -> Void) -> Cancellable? {
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

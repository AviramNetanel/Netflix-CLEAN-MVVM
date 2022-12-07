//
//  SeasonRepository.swift
//  netflix
//
//  Created by Zach Bazov on 11/10/2022.
//

import Foundation

private protocol RepositoryInput {
    func getSeason(with request: SeasonRequestDTO.GET,
                   completion: @escaping (Result<SeasonResponseDTO.GET, Error>) -> Void) -> Cancellable?
}

private protocol RepositoryOutput {
    var dataTransferService: DataTransferService { get }
}

private typealias Repository = RepositoryInput

struct SeasonRepository: Repository {
    fileprivate let dataTransferService: DataTransferService
    
    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

extension SeasonRepository {
    func getSeason(with request: SeasonRequestDTO.GET,
                   completion: @escaping (Result<SeasonResponseDTO.GET, Error>) -> Void) -> Cancellable? {
        let task = RepositoryTask()
        
        guard !task.isCancelled else { return nil }
        
        let endpoint = APIEndpoint.SeasonsRepository.getSeason(with: request)
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

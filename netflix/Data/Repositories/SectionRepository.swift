//
//  SectionRepository.swift
//  netflix
//
//  Created by Zach Bazov on 07/09/2022.
//

import Foundation

private protocol RepositoryInput {
    func getAll(completion: @escaping (Result<SectionResponseDTO.GET, Error>) -> Void) -> Cancellable?
}

private protocol RepositoryOutput {
    var dataTransferService: DataTransferService { get }
}

private typealias Repository = RepositoryInput & RepositoryOutput

final class SectionRepository: Repository {
    fileprivate let dataTransferService: DataTransferService
    
    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

extension SectionRepository {
    func getAll(completion: @escaping (Result<SectionResponseDTO.GET, Error>) -> Void) -> Cancellable? {
        let task = RepositoryTask()
        
        guard !task.isCancelled else { return nil }
        
        let endpoint = APIEndpoint.SectionsRepository.getAllSections()
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

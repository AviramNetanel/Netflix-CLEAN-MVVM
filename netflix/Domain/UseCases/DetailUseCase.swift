//
//  DetailUseCase.swift
//  netflix
//
//  Created by Zach Bazov on 12/10/2022.
//

import Foundation

private protocol UseCaseInput {
    func request<T>(for response: T.Type,
                    with request: SeasonRequestDTO.GET,
                    completion: @escaping (Result<SeasonResponse.GET, Error>) -> Void) -> Cancellable?
    func execute<T>(for response: T.Type,
                    with request: SeasonRequestDTO.GET,
                    completion: @escaping (Result<SeasonResponse.GET, Error>) -> Void) -> Cancellable?
}

private protocol UseCaseOutput {
    var seasonsRepository: SeasonRepository { get }
}

private typealias UseCase = UseCaseInput & UseCaseOutput

final class DetailUseCase: UseCase {
    fileprivate let seasonsRepository: SeasonRepository
    
    init(seasonsRepository: SeasonRepository) {
        self.seasonsRepository = seasonsRepository
    }
    
    fileprivate func request<T>(for response: T.Type,
                                with request: SeasonRequestDTO.GET,
                                completion: @escaping (Result<SeasonResponse.GET, Error>) -> Void) -> Cancellable? {
        return seasonsRepository.getSeason(with: request) { result in
            switch result {
            case .success(let response):
                completion(.success(response.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func execute<T>(for response: T.Type,
                    with request: SeasonRequestDTO.GET,
                    completion: @escaping (Result<SeasonResponse.GET, Error>) -> Void) -> Cancellable? {
        return self.request(for: response, with: request, completion: completion)
    }
}

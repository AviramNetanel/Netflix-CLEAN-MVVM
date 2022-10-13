//
//  DetailUseCase.swift
//  netflix
//
//  Created by Zach Bazov on 12/10/2022.
//

import Foundation

// MARK: - UseCaseInput protocol

private protocol UseCaseInput {
    func request<T>(for response: T.Type,
                    with viewModel: EpisodeCollectionViewCellViewModel,
                    completion: @escaping (Result<SeasonResponse, Error>) -> Void) -> Cancellable?
    func execute<T>(for response: T.Type,
                    with viewModel: EpisodeCollectionViewCellViewModel,
                    completion: @escaping (Result<SeasonResponse, Error>) -> Void) -> Cancellable?
}

// MARK: - UseCaseOutput protocol

private protocol UseCaseOutput {
    var seasonsRepository: SeasonsRepository { get }
}

// MARK: - UseCase typealias

private typealias UseCase = UseCaseInput & UseCaseOutput

// MARK: - DetailUseCase class

final class DetailUseCase: UseCase {
    
    fileprivate let seasonsRepository: SeasonsRepository
    
    init(seasonsRepository: SeasonsRepository) {
        self.seasonsRepository = seasonsRepository
    }
    
    fileprivate func request<T>(for response: T.Type,
                            with viewModel: EpisodeCollectionViewCellViewModel,
                            completion: @escaping (Result<SeasonResponse, Error>) -> Void) -> Cancellable? {
        return seasonsRepository.getSeason(with: viewModel) { result in
            switch result {
            case .success(let response):
                completion(.success(response.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func execute<T>(for response: T.Type,
                    with viewModel: EpisodeCollectionViewCellViewModel,
                    completion: @escaping (Result<SeasonResponse, Error>) -> Void) -> Cancellable? {
        return request(for: response, with: viewModel, completion: completion)
    }
}

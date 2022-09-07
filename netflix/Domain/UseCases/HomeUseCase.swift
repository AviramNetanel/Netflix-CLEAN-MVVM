//
//  HomeUseCase.swift
//  netflix
//
//  Created by Zach Bazov on 06/09/2022.
//

import Foundation

// MARK: - HomeUseCase protocol

protocol HomeUseCase {
    func execute(completion: @escaping (Result<TVShowsResponseDTO, Error>) -> Void) -> Cancellable?
}

// MARK: - DefaultHomeUseCase class

final class DefaultHomeUseCase: HomeUseCase {
    
    private let tvShowsRepository: TVShowsRepository
    private let moviesRepository: MoviesRepository
    
    init(tvShowsRepository: TVShowsRepository, moviesRepository: MoviesRepository) {
        self.tvShowsRepository = tvShowsRepository
        self.moviesRepository = moviesRepository
    }
    
    func execute(completion: @escaping (Result<TVShowsResponseDTO, Error>) -> Void) -> Cancellable? {
        return request(completion: completion)
    }
    
    // MARK: Private
    
    private func request(completion: @escaping (Result<TVShowsResponseDTO, Error>) -> Void) -> Cancellable? {
        return tvShowsRepository.getAll { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

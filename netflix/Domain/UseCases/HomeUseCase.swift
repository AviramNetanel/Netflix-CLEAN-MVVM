//
//  HomeUseCase.swift
//  netflix
//
//  Created by Zach Bazov on 06/09/2022.
//

import Foundation

// MARK: - HomeUseCase protocol

protocol HomeUseCase {
    func executeTVShows(completion: @escaping (Result<TVShowsResponse, Error>) -> Void) -> Cancellable?
    func executeMovies(completion: @escaping (Result<MoviesResponse, Error>) -> Void) -> Cancellable?
    func executeSections(completion: @escaping (Result<SectionsResponse, Error>) -> Void) -> Cancellable?
//    func execute<T, R>(for repository: T, completion: @escaping (Result<R, Error>) -> Void) -> Cancellable?
}

// MARK: - DefaultHomeUseCase class

final class DefaultHomeUseCase: HomeUseCase {
    
    private let sectionsRepository: SectionsRepository
    private let tvShowsRepository: TVShowsRepository
    private let moviesRepository: MoviesRepository
    
    init(sectionsRepository: SectionsRepository,
         tvShowsRepository: TVShowsRepository,
         moviesRepository: MoviesRepository) {
        self.sectionsRepository = sectionsRepository
        self.tvShowsRepository = tvShowsRepository
        self.moviesRepository = moviesRepository
    }
    
    // MARK: Private
    
    private func requestSections(completion: @escaping (Result<SectionsResponse, Error>) -> Void) -> Cancellable? {
        return sectionsRepository.getAll { result in
            switch result {
            case .success(let response):
                completion(.success(response.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func requestTVShows(completion: @escaping (Result<TVShowsResponse, Error>) -> Void) -> Cancellable? {
        return tvShowsRepository.getAll { result in
            switch result {
            case .success(let response):
                completion(.success(response.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func requestMovies(completion: @escaping (Result<MoviesResponse, Error>) -> Void) -> Cancellable? {
        return moviesRepository.getAll { result in
            switch result {
            case .success(let response):
                completion(.success(response.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - HomeUseCase implementation

extension DefaultHomeUseCase {
    
    func executeTVShows(completion: @escaping (Result<TVShowsResponse, Error>) -> Void) -> Cancellable? {
        return requestTVShows(completion: completion)
    }
    
    func executeMovies(completion: @escaping (Result<MoviesResponse, Error>) -> Void) -> Cancellable? {
        return requestMovies(completion: completion)
    }
    
    func executeSections(completion: @escaping (Result<SectionsResponse, Error>) -> Void) -> Cancellable? {
        return requestSections(completion: completion)
    }
}

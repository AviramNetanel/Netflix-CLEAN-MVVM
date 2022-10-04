//
//  HomeUseCase.swift
//  netflix
//
//  Created by Zach Bazov on 06/09/2022.
//

import Foundation

// MARK: - UseCaseInput protocol

private protocol UseCaseInput {
    func executeTVShows(completion: @escaping (Result<TVShowsResponse, Error>) -> Void) -> Cancellable?
    func executeMovies(completion: @escaping (Result<MoviesResponse, Error>) -> Void) -> Cancellable?
    func executeSections(completion: @escaping (Result<SectionsResponse, Error>) -> Void) -> Cancellable?
//    func execute<T, R>(for repository: T, completion: @escaping (Result<R, Error>) -> Void) -> Cancellable?
}

// MARK: - UseCaseOutput protocol

private protocol UseCaseOutput {
    var sectionsRepository: SectionsRepository { get }
    var tvShowsRepository: TVShowsRepository { get }
    var moviesRepository: MoviesRepository { get }
}

// MARK: - UseCase typealias

private typealias UseCase = UseCaseInput & UseCaseOutput

// MARK: - HomeUseCase class

final class HomeUseCase: UseCase {
    
    fileprivate let sectionsRepository: SectionsRepository
    fileprivate let tvShowsRepository: TVShowsRepository
    fileprivate let moviesRepository: MoviesRepository
    
    init(sectionsRepository: SectionsRepository,
         tvShowsRepository: TVShowsRepository,
         moviesRepository: MoviesRepository) {
        self.sectionsRepository = sectionsRepository
        self.tvShowsRepository = tvShowsRepository
        self.moviesRepository = moviesRepository
    }
    
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

// MARK: - UseCaseInput implementation

extension HomeUseCase {
    
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

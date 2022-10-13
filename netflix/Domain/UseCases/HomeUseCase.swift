//
//  HomeUseCase.swift
//  netflix
//
//  Created by Zach Bazov on 06/09/2022.
//

import Foundation

// MARK: - UseCaseInput protocol

private protocol UseCaseInput {
    func request<T>(for response: T.Type,
                    completion: @escaping (Result<T, Error>) -> Void) -> Cancellable?
    func execute<T>(for response: T.Type,
                    completion: @escaping (Result<T, Error>) -> Void) -> Cancellable?
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
    
    fileprivate func request<T>(for response: T.Type,
                                completion: @escaping (Result<T, Error>) -> Void) -> Cancellable? {
        switch response {
        case is TVShowsResponse.Type:
            return tvShowsRepository.getAll { result in
                switch result {
                case .success(let response):
                    completion(.success(response.toDomain() as! T))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        case is MoviesResponse.Type:
            return moviesRepository.getAll { result in
                switch result {
                case .success(let response):
                    completion(.success(response.toDomain() as! T))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        case is SectionsResponse.Type:
            return sectionsRepository.getAll { result in
                switch result {
                case .success(let response):
                    completion(.success(response.toDomain() as! T))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        default: return nil
        }
    }
    
    func execute<T>(for response: T.Type,
                    completion: @escaping (Result<T, Error>) -> Void) -> Cancellable? {
        return request(for: response, completion: completion)
    }
}

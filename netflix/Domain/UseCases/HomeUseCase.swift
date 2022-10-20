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
                    query: MediaRequestQuery?,
                    cached: @escaping (T?) -> Void,
                    completion: @escaping (Result<T, Error>) -> Void) async -> Cancellable?
    func execute<T>(for response: T.Type,
                    query: MediaRequestQuery?,
                    cached: @escaping (T?) -> Void,
                    completion: @escaping (Result<T, Error>) -> Void) async -> Cancellable?
}

// MARK: - UseCaseOutput protocol

private protocol UseCaseOutput {
    var sectionsRepository: SectionsRepository { get }
    var mediaRepository: MediaRepository { get }
}

// MARK: - UseCase typealias

private typealias UseCase = UseCaseInput & UseCaseOutput

// MARK: - HomeUseCase class

final class HomeUseCase: UseCase {
    
    fileprivate let sectionsRepository: SectionsRepository
    fileprivate(set) var mediaRepository: MediaRepository
    
    init(sectionsRepository: SectionsRepository,
         mediaRepository: MediaRepository) {
        self.sectionsRepository = sectionsRepository
        self.mediaRepository = mediaRepository
    }
    
    fileprivate func request<T>(for response: T.Type,
                                query: MediaRequestQuery? = nil,
                                cached: @escaping (T?) -> Void,
                                completion: @escaping (Result<T, Error>) -> Void) async -> Cancellable? {
        switch response {
        case is SectionsResponse.Type:
            return sectionsRepository.getAll { result in
                switch result {
                case .success(let response):
                    completion(.success(response.toDomain() as! T))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        case is MediasResponse.Type:
            return mediaRepository.getAll { result in
                switch result {
                case .success(let response):
                    cached(response as? T)
                    completion(.success(response.toDomain() as! T))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        case is MediaResponse.Type:
            guard let query = query else { return nil }
            let requestDTO = MediaRequestDTO(user: query.user,
                                             id: query.media.id,
                                             slug: query.media.slug)
            let requestQuery = MediaRequestQuery(user: query.user,
                                                 media: requestDTO)
            return mediaRepository.getOne(
                query: requestQuery,
                cached: { _ in },
                completion: { result in
                    switch result {
                    case .success(let response):
                        completion(.success(response as! T))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                })
        default: return nil
        }
    }
    
    func execute<T>(for response: T.Type,
                    query: MediaRequestQuery? = nil,
                    cached: @escaping (T?) -> Void,
                    completion: @escaping (Result<T, Error>) -> Void) async -> Cancellable? {
        return await request(for: response,
                             query: query,
                             cached: cached,
                             completion: completion)
    }
}

//
//  HomeUseCase.swift
//  netflix
//
//  Created by Zach Bazov on 06/09/2022.
//

import Foundation

// MARK: - UseCaseInput protocol

private protocol UseCaseInput {
    func request<T, U>(for response: T.Type,
                       request: U?,
                       cached: ((T?) -> Void)?,
                       completion: ((Result<T, Error>) -> Void)?) -> Cancellable?
    func execute<T, U>(for response: T.Type,
                       request: U?,
                       cached: ((T?) -> Void)?,
                       completion: ((Result<T, Error>) -> Void)?) -> Cancellable?
}

// MARK: - UseCaseOutput protocol

private protocol UseCaseOutput {
    var sectionsRepository: SectionRepository { get }
    var mediaRepository: MediaRepository { get }
    var myListRepository: MyListRepository { get }
}

// MARK: - UseCase typealias

private typealias UseCase = UseCaseInput & UseCaseOutput

// MARK: - HomeUseCase class

final class HomeUseCase: UseCase {
    
    fileprivate let sectionsRepository: SectionRepository
    fileprivate(set) var mediaRepository: MediaRepository
    fileprivate(set) var myListRepository: MyListRepository
    
    init(sectionsRepository: SectionRepository,
         mediaRepository: MediaRepository,
         myListRepository: MyListRepository) {
        self.sectionsRepository = sectionsRepository
        self.mediaRepository = mediaRepository
        self.myListRepository = myListRepository
    }
    
    fileprivate func request<T, U>(for response: T.Type,
                                   request: U? = nil,
                                   cached: ((T?) -> Void)?,
                                   completion: ((Result<T, Error>) -> Void)?) -> Cancellable? {
        switch response {
        case is SectionResponse.GET.Type:
            return sectionsRepository.getAll { result in
                switch result {
                case .success(let response):
                    cached?(response as? T)
                    completion?(.success(response.toDomain() as! T))
                case .failure(let error):
                    completion?(.failure(error))
                }
            }
        case is MediaResponse.GET.Many.Type:
            return mediaRepository.getAll { result in
                switch result {
                case .success(let response):
                    cached?(response as? T)
                    completion?(.success(response.toDomain() as! T))
                case .failure(let error):
                    completion?(.failure(error))
                }
            }
        case is MediaResponse.GET.One.Type:
            guard let request = request as? MediaRequestDTO.GET.One else { return nil }
            let requestDTO = MediaRequestDTO.GET.One(user: request.user,
                                                     id: request.id,
                                                     slug: request.slug)
            return mediaRepository.getOne(
                request: requestDTO,
                cached: { _ in },
                completion: { result in
                    switch result {
                    case .success(let response):
                        completion?(.success(response as! T))
                    case .failure(let error):
                        completion?(.failure(error))
                    }
                })
        case is MyListResponseDTO.GET.Type:
            guard let request = request as? MyListRequestDTO.GET else { return nil }
            return myListRepository.getOne(
                request: request,
                completion: { result in
                    switch result {
                    case .success(let response):
                        completion?(.success(response as! T))
                    case .failure(let error):
                        completion?(.failure(error))
                    }
                })
        case is MyListResponseDTO.POST.Type:
            guard let request = request as? MyListRequestDTO.POST else { return nil }
            return myListRepository.createOne(
                request: request,
                completion: { result in
                    switch result {
                    case .success(let response):
                        completion?(.success(response as! T))
                    case .failure(let error):
                        completion?(.failure(error))
                    }
                })
        case is MyListResponseDTO.PATCH.Type:
            guard let request = request as? MyListRequestDTO.PATCH else { return nil }
            return myListRepository.updateOne(request: request) { result in
                switch result {
                case .success(let response):
                    completion?(.success(response as! T))
                case .failure(let error):
                    completion?(.failure(error))
                }
            }
        default: return nil
        }
    }
    
    func execute<T, U>(for response: T.Type,
                       request: U? = nil,
                       cached: ((T?) -> Void)?,
                       completion: ((Result<T, Error>) -> Void)?) -> Cancellable? {
        return self.request(for: response,
                            request: request,
                            cached: cached ?? { _ in },
                            completion: completion ?? { _ in })
    }
}

//
//  HomeViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 05/09/2022.
//

import Foundation

// MARK: - HomeViewModelActions struct

struct HomeViewModelActions {
    
}

// MARK: - HomeViewModelInput protocol

protocol HomeViewModelInput {
    func viewDidLoad()
    func getTVShows(completion: @escaping (Result<TVShowsResponseDTO, Error>) -> Void)
}

// MARK: - HomeViewModelOutput protocol

protocol HomeViewModelOutput {
    var items: Observable<[MediaDTO]> { get }
}

// MARK: - HomeViewModel protocol

protocol HomeViewModel: HomeViewModelInput, HomeViewModelOutput {}

// MARK: - HomeViewModel class

final class DefaultHomeViewModel: HomeViewModel {
    
    private let homeUseCase: HomeUseCase
    private let actions: HomeViewModelActions
    
    private var task: Cancellable? {
        willSet {
            task?.cancel()
        }
    }
    
    // MARK: Output
    
    var items: Observable<[MediaDTO]> = Observable([])
    
    init(homeUseCase: HomeUseCase,
         actions: HomeViewModelActions) {
        self.homeUseCase = homeUseCase
        self.actions = actions
    }
}

// MARK: - HomeViewModel implementation

extension DefaultHomeViewModel {
    
    func viewDidLoad() {}
    
    func getTVShows(completion: @escaping (Result<TVShowsResponseDTO, Error>) -> Void) {
        task = homeUseCase.execute(completion: { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}

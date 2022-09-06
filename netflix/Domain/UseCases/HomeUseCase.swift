//
//  HomeUseCase.swift
//  netflix
//
//  Created by Zach Bazov on 06/09/2022.
//

import Foundation

// MARK: - HomeUseCase protocol

protocol HomeUseCase {
    func execute() -> Cancellable?
}

// MARK: - DefaultHomeUseCase class

final class DefaultHomeUseCase: HomeUseCase {
    
    private let tvShowsRepository: TVShowsRepository
    private let moviesRepository: MoviesRepository
    
    init(tvShowsRepository: TVShowsRepository, moviesRepository: MoviesRepository) {
        self.tvShowsRepository = tvShowsRepository
        self.moviesRepository = moviesRepository
    }
    
    func execute() -> Cancellable? {
        return nil
    }
}

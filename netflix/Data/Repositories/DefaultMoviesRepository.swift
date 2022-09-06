//
//  DefaultMoviesRepository.swift
//  netflix
//
//  Created by Zach Bazov on 06/09/2022.
//

import Foundation

// MARK: - DefaultMoviesRepository class

final class DefaultMoviesRepository {
    
    private let dataTransferService: DataTransferService
    
    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

// MARK: - MoviesRepository implementation

extension DefaultMoviesRepository: MoviesRepository {
    
}

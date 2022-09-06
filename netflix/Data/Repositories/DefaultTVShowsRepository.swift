//
//  DefaultTVShowsRepository.swift
//  netflix
//
//  Created by Zach Bazov on 06/09/2022.
//

import Foundation

// MARK: - DefaultTVShowsRepository class

final class DefaultTVShowsRepository {
    
    private let dataTramsferService: DataTransferService
    
    init(dataTransferService: DataTransferService) {
        self.dataTramsferService = dataTransferService
    }
}

// MARK: - TVShowsRepository implementation

extension DefaultTVShowsRepository: TVShowsRepository {
    
}

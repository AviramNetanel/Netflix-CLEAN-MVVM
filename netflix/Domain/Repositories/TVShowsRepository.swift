//
//  TVShowsRepository.swift
//  netflix
//
//  Created by Zach Bazov on 01/09/2022.
//

import Foundation

protocol Repository {}

// MARK: - TVShowsRepository protocol

protocol TVShowsRepository {
    func getAll(completion: @escaping (Result<TVShowsResponseDTO, Error>) -> Void) -> Cancellable?
}



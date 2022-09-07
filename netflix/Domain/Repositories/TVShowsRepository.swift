//
//  TVShowsRepository.swift
//  netflix
//
//  Created by Zach Bazov on 01/09/2022.
//

import Foundation

// MARK: - TVShowsRepository protocol

protocol TVShowsRepository {
    func getAll(completion: @escaping (Result<TVShowsResponseDTO, Error>) -> Void) -> Cancellable?
}

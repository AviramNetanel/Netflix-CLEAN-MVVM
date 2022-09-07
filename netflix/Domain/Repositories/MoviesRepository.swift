//
//  MoviesRepository.swift
//  netflix
//
//  Created by Zach Bazov on 01/09/2022.
//

import Foundation

// MARK: - MoviesRepository

protocol MoviesRepository {
    func getAll(completion: @escaping (Result<MoviesResponseDTO, Error>) -> Void) -> Cancellable?
}

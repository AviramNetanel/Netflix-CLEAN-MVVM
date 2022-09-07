//
//  SectionsRepository.swift
//  netflix
//
//  Created by Zach Bazov on 01/09/2022.
//

import Foundation

// MARK: - SectionsRepository protocol

protocol SectionsRepository {
    func getAll(completion: @escaping (Result<SectionsResponseDTO, Error>) -> Void) -> Cancellable?
}

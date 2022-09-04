//
//  AuthResponseStorage.swift
//  netflix
//
//  Created by Zach Bazov on 01/09/2022.
//

import CoreData

// MARK: - AuthResponseStorage protocol

protocol AuthResponseStorage {
    func getResponse(for request: AuthRequestDTO,
                     completion: @escaping (Result<AuthResponseDTO?, CoreDataStorageError>) -> Void)
    func save(response: AuthResponseDTO, for request: AuthRequestDTO)
    func deleteResponse(for request: AuthRequestDTO, in context: NSManagedObjectContext)
}

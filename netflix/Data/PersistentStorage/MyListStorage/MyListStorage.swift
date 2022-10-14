//
//  MyListStorage.swift
//  netflix
//
//  Created by Zach Bazov on 13/10/2022.
//

import Foundation

// MARK: - StorageInput protocol

private protocol StorageInput {
    
}

// MARK: - StorageOutput protocol

private protocol StorageOutput {
    
}

// MARK: - Storage typealias

private typealias Storage = StorageInput & StorageOutput

// MARK: - MyListStorage class

final class MyListStorage: Storage {
    
    fileprivate let coreDataStorage: CoreDataStorage
    
    init(coreDataStorage: CoreDataStorage = .shared) {
        self.coreDataStorage = coreDataStorage
    }
    
    
}

//
//  CoreDataStorage.swift
//  netflix
//
//  Created by Zach Bazov on 01/09/2022.
//

import CoreData

// MARK: - CoreDataStorageError enum

enum CoreDataStorageError: Error {
    case readError(Error)
    case saveError(Error)
    case deleteError(Error)
}

// MARK: - CoreDataStorage class

final class CoreDataStorage {
    
    static let shared = CoreDataStorage()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        ValueTransformer.setValueTransformer(AnyTransformer(), forName: .userToDataTransformer)

        let container = NSPersistentContainer(name: "CoreDataStorage")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                assertionFailure("CoreDataStorage unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private init() {}
    
    func saveContext() {
        let context = persistentContainer.viewContext
        
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            assertionFailure("CoreDataStorage unresolved error \(error), \((error as NSError).userInfo)")
        }
    }
    
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(block)
    }
    
    private func url(for container: NSPersistentContainer) -> URL? {
        let persistentStore = container.persistentStoreCoordinator.persistentStores.first!
        let url = container.persistentStoreCoordinator.url(for: persistentStore)
        printIfDebug("persistentStore url \(url)")
        return url
    }
}

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

// MARK: - StorageInput protocol

private protocol StorageInput {
    init()
    func url(for container: NSPersistentContainer) -> URL?
    func transformersDidRegister()
    func context() -> NSManagedObjectContext
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void)
    func saveContext()
}

// MARK: - StorageOutput protocol

private protocol StorageOutput {
    static var shared: CoreDataStorage { get }
    var persistentContainer: NSPersistentContainer { get }
}

// MARK: - Storage typealias

private typealias Storage = StorageInput & StorageOutput

// MARK: - CoreDataStorage class

final class CoreDataStorage: Storage {
    
    static let shared = CoreDataStorage()
    
    fileprivate lazy var persistentContainer: NSPersistentContainer = {
        transformersDidRegister()

        let container = NSPersistentContainer(name: "CoreDataStorage")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                assertionFailure("CoreDataStorage unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    fileprivate init() {}
    
    fileprivate func url(for container: NSPersistentContainer) -> URL? {
        let persistentStore = container.persistentStoreCoordinator.persistentStores.first!
        let url = container.persistentStoreCoordinator.url(for: persistentStore)
        printIfDebug("persistentStore url \(url)")
        return url
    }
    
    fileprivate func transformersDidRegister() {
        ValueTransformer.setValueTransformer(ValueTransformer<UserDTO>(),
                                             forName: .userTransformer)
        ValueTransformer.setValueTransformer(ValueTransformer<MediaResourcesDTO>(),
                                             forName: .mediaResourcesTransformer)
    }
    
    func context() -> NSManagedObjectContext { persistentContainer.viewContext }
    
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(block)
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        
        guard context.hasChanges else { return }
        
        do { try context.save() }
        catch { assertionFailure("CoreDataStorage unresolved error \(error), \((error as NSError).userInfo)") }
    }
}

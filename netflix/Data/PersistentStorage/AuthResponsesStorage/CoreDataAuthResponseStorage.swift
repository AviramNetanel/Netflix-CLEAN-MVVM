//
//  CoreDataAuthResponseStorage.swift
//  netflix
//
//  Created by Zach Bazov on 01/09/2022.
//

import CoreData

// MARK: - CoreDataAuthResponseStorage class

final class CoreDataAuthResponseStorage {
    
    private let coreDataStorage: CoreDataStorage
    
    init(coreDataStorage: CoreDataStorage = .shared) {
        self.coreDataStorage = coreDataStorage
    }
    
    // MARK: Private
    
    private func fetchRequest(for requestDTO: AuthRequestDTO) -> NSFetchRequest<AuthRequestEntity> {
        let request: NSFetchRequest = AuthRequestEntity.fetchRequest()
        request.predicate = NSPredicate(format: "%K = %@", #keyPath(AuthRequestEntity.user), requestDTO.user)
        return request
    }
}

// MARK: - AuthResponseStorage implementation

extension CoreDataAuthResponseStorage: AuthResponseStorage {
    
    func getResponse(for request: AuthRequestDTO,
                     completion: @escaping (Result<AuthResponseDTO?, CoreDataStorageError>) -> Void) {
        coreDataStorage.performBackgroundTask { context in
            do {
                let fetchRequest = self.fetchRequest(for: request)
                let requestEntity = try context.fetch(fetchRequest).first
                
                completion(.success(requestEntity?.response?.toDTO()))
            } catch {
                completion(.failure(CoreDataStorageError.readError(error)))
            }
        }
    }
    
    func save(response: AuthResponseDTO, for request: AuthRequestDTO) {
        coreDataStorage.performBackgroundTask { context in
            do {
                self.deleteResponse(for: request, in: context)
                
                let requestEntity: AuthRequestEntity = request.toEntity(in: context)
                let responseEntity: AuthResponseEntity = response.toEntity(in: context)
                
                requestEntity.response = responseEntity
                requestEntity.user = request.user
                
                responseEntity.request = requestEntity
                responseEntity.token = response.token
                responseEntity.data = response.data
                
                try context.save()
            } catch {
                debugPrint("CoreDataAuthResponseStorage unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }
    
    func deleteResponse(for request: AuthRequestDTO, in context: NSManagedObjectContext) {
        let fetchRequest = fetchRequest(for: request)
        
        do {
            if let result = try context.fetch(fetchRequest) as [AuthRequestEntity]? {
                for r in result {
                    context.delete(r)
                }
            }
        } catch {
            print("Unresolved error \(error) occured as trying to delete object.")
        }
    }
}

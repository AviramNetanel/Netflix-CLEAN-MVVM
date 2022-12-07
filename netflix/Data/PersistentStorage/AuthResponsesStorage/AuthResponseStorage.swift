//
//  AuthResponseStorage.swift
//  netflix
//
//  Created by Zach Bazov on 01/09/2022.
//

import CoreData

private protocol StorageInput {
    func fetchRequest(for requestDTO: AuthRequestDTO) -> NSFetchRequest<AuthRequestEntity>
    func getResponse(for request: AuthRequestDTO,
                     completion: @escaping (Result<AuthResponseDTO?, CoreDataStorageError>) -> Void)
    func save(response: AuthResponseDTO,
              for request: AuthRequestDTO)
    func deleteResponse(for request: AuthRequestDTO,
                        in context: NSManagedObjectContext)
}

private protocol StorageOutput {
    var coreDataStorage: CoreDataStorage { get }
}

private typealias Storage = StorageInput & StorageOutput

final class AuthResponseStorage: Storage {
    fileprivate let coreDataStorage: CoreDataStorage
    fileprivate let authService: AuthService
    
    init(coreDataStorage: CoreDataStorage = .shared,
         authService: AuthService) {
        self.coreDataStorage = coreDataStorage
        self.authService = authService
    }
    
    fileprivate func fetchRequest(for requestDTO: AuthRequestDTO) -> NSFetchRequest<AuthRequestEntity> {
        let request: NSFetchRequest = AuthRequestEntity.fetchRequest()
        request.predicate = NSPredicate(format: "%K = %@",
                                        #keyPath(AuthRequestEntity.user),
                                        requestDTO.user)
        return request
    }
}

extension AuthResponseStorage {
    func getResponse(for request: AuthRequestDTO,
                     completion: @escaping (Result<AuthResponseDTO?, CoreDataStorageError>) -> Void) {
        coreDataStorage.performBackgroundTask { [weak self] context in
            guard let self = self else { return }
            do {
                let fetchRequest = self.fetchRequest(for: request)
                let requestEntity = try context.fetch(fetchRequest).first
                
                self.authService.user = requestEntity?.response?.data
                
                completion(.success(requestEntity?.response?.toDTO()))
            } catch {
                completion(.failure(CoreDataStorageError.readError(error)))
            }
        }
    }
    
    func save(response: AuthResponseDTO, for request: AuthRequestDTO) {
        coreDataStorage.performBackgroundTask { [weak self] context in
            guard let self = self else { return }
            do {
                self.deleteResponse(for: request, in: context)
                
                let requestEntity: AuthRequestEntity = request.toEntity(in: context)
                let responseEntity: AuthResponseEntity = response.toEntity(in: context)
                
                requestEntity.response = responseEntity
                requestEntity.user = request.user
                
                responseEntity.request = requestEntity
                responseEntity.token = response.token
                responseEntity.data = response.data
                
                self.authService.user = response.data
                
                try context.save()
            } catch {
                printIfDebug("CoreDataAuthResponseStorage unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }
    
    func deleteResponse(for request: AuthRequestDTO, in context: NSManagedObjectContext) {
        let fetchRequest = fetchRequest(for: request)
        do {
            if let result = try context.fetch(fetchRequest) as [AuthRequestEntity]? {
                for r in result {
                    context.delete(r)
                    context.delete(r.response!)
                }
            }
        } catch {
            printIfDebug("Unresolved error \(error) occured as trying to delete object.")
        }
    }
}

//
//  AuthService.swift
//  netflix
//
//  Created by Zach Bazov on 20/11/2022.
//

import Foundation

final class AuthService {
    private let coreDataStorage: CoreDataStorage = .shared
    
    var user: UserDTO?
    
    var latestCachedUser: UserDTO? {
        let request = AuthRequestEntity.fetchRequest()
        do {
            guard
                let entities = try coreDataStorage.context().fetch(request) as [AuthRequestEntity]?,
                let lastKnownEntity = entities.last
            else { return nil }
            return UserDTO(email: lastKnownEntity.user!.email, password: lastKnownEntity.user!.password)
        } catch {
            printIfDebug("Unresolved error \(error) ")
        }
        return nil
    }
    
    func performCachedAuthorizationSession(_ completion: @escaping (AuthRequest) -> Void) {
        guard
            let email = latestCachedUser?.email,
            let password = latestCachedUser?.password
        else { return }
        let userDTO = UserDTO(email: email, password: password)
        let requestDTO = AuthRequestDTO(user: userDTO)
        let requestQuery = AuthRequestDTO(user: requestDTO.user)
        
        completion(requestQuery.toDomain())
    }
    
    func assignUser(user: UserDTO?) {
        self.user = user
    }
}

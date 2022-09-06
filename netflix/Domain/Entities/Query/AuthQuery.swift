//
//  AuthQuery.swift
//  netflix
//
//  Created by Zach Bazov on 02/09/2022.
//

import Foundation

// MARK: - AuthQuery class

@objc
final class AuthQuery: NSObject {
    let user: UserDTO
    
    init(user: UserDTO) {
        self.user = user
    }
}

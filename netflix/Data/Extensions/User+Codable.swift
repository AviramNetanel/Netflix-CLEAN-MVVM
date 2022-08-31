//
//  User+Codable.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import Foundation

// MARK: - Codable implementation

extension User: Codable {
    
    enum CodingKeys: String, CodingKey {
        case name,
             email,
             password,
             passwordConfirm,
             role,
             active
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name = try container.decode(String.self, forKey: .name)
        let email = try container.decode(String.self, forKey: .email)
        let password = try container.decode(String.self, forKey: .password)
        let passwordConfirm = try container.decode(String.self, forKey: .passwordConfirm)
        let role = try container.decode(String.self, forKey: .role)
        let active = try container.decode(Bool.self, forKey: .active)
        
        self.name = name
        self.email = email
        self.password = password
        self.passwordConfirm = passwordConfirm
        self.role = role
        self.active = active
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
        try container.encode(password, forKey: .password)
        try container.encode(passwordConfirm, forKey: .passwordConfirm)
        try container.encode(role, forKey: .role)
        try container.encode(active, forKey: .active)
    }
}

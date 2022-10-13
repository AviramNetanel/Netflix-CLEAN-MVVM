//
//  UserDTO+Mapping.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import CoreData

// MARK: - UserDTO class

@objc(UserDTO)
public final class UserDTO: NSObject, Codable, NSSecureCoding {
    
    private enum CodingKeys: String, CodingKey {
        case name,
             email,
             password,
             passwordConfirm,
             role,
             active
    }
    
    var name: String?
    var email: String?
    var password: String?
    var passwordConfirm: String?
    var role: String?
    var active: Bool?
    
    init(name: String? = nil,
         email: String? = nil,
         password: String? = nil,
         passwordConfirm: String? = nil,
         role: String? = nil,
         active: Bool? = nil) {
        self.name = name
        self.email = email
        self.password = password
        self.passwordConfirm = passwordConfirm
        self.role = role
        self.active = active
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name = try container.decodeIfPresent(String.self, forKey: .name)
        let email = try container.decodeIfPresent(String.self, forKey: .email)
        let password = try container.decodeIfPresent(String.self, forKey: .password)
        let passwordConfirm = try container.decodeIfPresent(String.self, forKey: .passwordConfirm)
        let role = try container.decodeIfPresent(String.self, forKey: .role)
        let active = try container.decodeIfPresent(Bool.self, forKey: .active)
        
        self.name = name
        self.email = email
        self.password = password
        self.passwordConfirm = passwordConfirm
        self.role = role
        self.active = active
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encode(email, forKey: .email)
        try container.encode(password, forKey: .password)
        try container.encodeIfPresent(passwordConfirm, forKey: .passwordConfirm)
        try container.encodeIfPresent(role, forKey: .role)
        try container.encodeIfPresent(active, forKey: .active)
    }
    
    // MARK: NSSecureCoding
    
    public static var supportsSecureCoding: Bool {
        return true
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(email, forKey: "email")
        coder.encode(password, forKey: "password")
        coder.encode(passwordConfirm, forKey: "passwordConfirm")
        coder.encode(role, forKey: "role")
        coder.encode(active, forKey: "active")
    }
    
    public required init?(coder: NSCoder) {
        self.name = coder.decodeObject(of: [UserDTO.self, NSString.self], forKey: "name") as? String
        self.email = coder.decodeObject(of: [UserDTO.self, NSString.self], forKey: "email") as? String
        self.password = coder.decodeObject(of: [UserDTO.self, NSString.self], forKey: "password") as? String
        self.passwordConfirm = coder.decodeObject(of: [UserDTO.self, NSString.self], forKey: "passwordConfirm") as? String
        self.role = coder.decodeObject(of: [UserDTO.self, NSString.self], forKey: "role") as? String
        self.active = coder.decodeObject(of: [UserDTO.self, NSString.self], forKey: "active") as? Bool
    }
}

// MARK: - Mapping

extension UserDTO {
    func toDomain() -> User {
        return .init(name: name,
                     email: email,
                     password: password,
                     passwordConfirm: passwordConfirm,
                     role: role,
                     active: active)
    }
}

extension UserDTO {
    func toEntity(in context: NSManagedObjectContext) -> UserEntity? {
        let entity: UserEntity = .init(context: context)
        entity.name = name
        entity.email = email
        entity.password = password
        entity.passwordConfirm = passwordConfirm
        entity.role = role
        entity.active = active ?? true
        return entity
    }
}

//
//  AnyTransformer.swift
//  netflix
//
//  Created by Zach Bazov on 01/09/2022.
//

import Foundation

// MARK: - AnyTransformer class

final class AnyTransformer: NSSecureUnarchiveFromDataTransformer {
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override class func transformedValueClass() -> AnyClass {
        return UserDTO.self
    }
    
    override class var allowedTopLevelClasses: [AnyClass] {
        return [UserDTO.self]
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else {
            fatalError("Wrong data type: value must be a Data object, received \(type(of: value)).")
        }
        return super.transformedValue(data)
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let color = value as? UserDTO else {
            fatalError("Wrong data type: value must be a UIColor object, received \(type(of: value)).")
        }
        return super.reverseTransformedValue(color)
    }
}

// MARK: - NSValueTransformerName

extension NSValueTransformerName {
    static let userToDataTransformer = NSValueTransformerName(rawValue: "UserToDataTransformer")
}

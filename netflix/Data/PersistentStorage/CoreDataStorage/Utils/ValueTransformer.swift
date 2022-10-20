//
//  ValueTransformer.swift
//  netflix
//
//  Created by Zach Bazov on 01/09/2022.
//

import Foundation

// MARK: - ValueTransformerValue enum

private enum ValueTransformerValue: String {
    case user = "UserTransformer"
    case mediaResources = "MediaResourcesTransformer"
}

// MARK: - NSValueTransformerName extension

extension NSValueTransformerName {
    static let userTransformer = NSValueTransformerName(rawValue: ValueTransformerValue.user.rawValue)
    static let mediaResourcesTransformer = NSValueTransformerName(rawValue: ValueTransformerValue.mediaResources.rawValue)
}

// MARK: - ValueTransformer class

final class ValueTransformer<T: NSObject>: NSSecureUnarchiveFromDataTransformer {
    
    override class func allowsReverseTransformation() -> Bool { true }
    override class func transformedValueClass() -> AnyClass { T.self }
    override class var allowedTopLevelClasses: [AnyClass] { [T.self] }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else {
            fatalError("Wrong data type: value must be a `MediaResources` object, received \(type(of: value)).")
        }
        return super.transformedValue(data)
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let value = value as? T else {
            fatalError("Wrong data type: value must be a `MediaResources` object, received \(type(of: value)).")
        }
        return super.reverseTransformedValue(value)
    }
}

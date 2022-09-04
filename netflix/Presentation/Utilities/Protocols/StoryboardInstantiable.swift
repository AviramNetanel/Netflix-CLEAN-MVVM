//
//  StoryboardInstantiable.swift
//  netflix
//
//  Created by Zach Bazov on 05/09/2022.
//

import UIKit

// MARK: - StoryboardInstantiable protocol

protocol StoryboardInstantiable {
    associatedtype T
    static var defaultFileName: String { get }
    static func instantiateViewController(_ bundle: Bundle?) -> T
}

// MARK: - StoryboardInstantiable's default implementation

extension StoryboardInstantiable where Self: UIViewController {
    
    static var defaultFileName: String {
        return NSStringFromClass(Self.self).components(separatedBy: ".").last!
    }
    
    static func instantiateViewController(_ bundle: Bundle? = nil) -> Self {
        let fileName = defaultFileName
        let storyboard = UIStoryboard(name: fileName, bundle: bundle)
        guard let viewController = storyboard.instantiateInitialViewController() as? Self else {
            fatalError("Cannot instantiate initial view controller \(Self.self) from storyboard with name \(fileName)")
        }
        return viewController
    }
}

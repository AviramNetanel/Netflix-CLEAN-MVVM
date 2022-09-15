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
    static func instantiateViewController(_ bundle: Bundle?, withIdentifier identifier: String?) -> T
}

// MARK: - Default implementation

extension StoryboardInstantiable where Self: UIViewController {
    
    static var defaultFileName: String {
        return NSStringFromClass(Self.self).components(separatedBy: ".").last!
    }
    
    static func instantiateViewController(_ bundle: Bundle? = nil, withIdentifier identifier: String? = nil) -> Self {
        let fileName = defaultFileName
        let storyboard = UIStoryboard(name: fileName, bundle: bundle)
        let condition = identifier != nil ? storyboard.instantiateViewController(withIdentifier: identifier!) : storyboard.instantiateInitialViewController()
        guard let viewController = condition as? Self else {
            fatalError("Cannot instantiate initial view controller \(Self.self) from storyboard with name \(fileName)")
        }
        return viewController
    }
}

protocol ViewInstantiable: UIView {}
extension ViewInstantiable {
    func nibDidLoad() {
        let view = Bundle.main.loadNibNamed(String(describing: Self.self), owner: self, options: nil)![0] as! UIView
        addSubview(view)
    }
}

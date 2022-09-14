//
//  UIViewController+Extension.swift
//  netflix
//
//  Created by Zach Bazov on 14/09/2022.
//

import UIKit

// MARK: - UIViewController + Scene Delegate

extension UIViewController {
    var sceneDelegate: SceneDelegate? {
        return UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
    }
}

// MARK: - UIViewController + Add Child

extension UIViewController {
    
    func add(child: UIViewController, container: UIView) {
        addChild(child)
        
        child.view.frame = container.bounds
        container.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        guard parent != nil else { return }
        
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
}

// MARK: - UIViewController + Set Attributes

extension UIViewController {
    func setAttributes(for fields: [UITextField]) {
        for field in fields {
            field.setPlaceholderAtrributes(string: field.placeholder ?? .init(), attributes: NSAttributedString.placeholderAttributes)
        }
    }
}

//
//  UIViewController+Extension.swift
//  netflix
//
//  Created by Zach Bazov on 14/09/2022.
//

import UIKit

extension UIViewController {
    var sceneDelegate: SceneDelegate? {
        return UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
    }
}

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

extension UIViewController {
    func setAttributes(for fields: [UITextField]) {
        for field in fields {
            field.setPlaceholderAtrributes(string: field.placeholder ?? .init(), attributes: NSAttributedString.placeholderAttributes)
        }
    }
}

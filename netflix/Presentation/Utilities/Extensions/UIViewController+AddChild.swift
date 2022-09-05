//
//  UIViewController+AddChild.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import UIKit

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
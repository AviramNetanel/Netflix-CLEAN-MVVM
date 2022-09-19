//
//  UIView+Animations.swift
//  netflix
//
//  Created by Zach Bazov on 19/09/2022.
//

import UIKit

// MARK: - UIView + Spring Animation

extension UIView {
    func animateUsingSpring(withDuration duration: TimeInterval,
                            withDamping damping: CGFloat,
                            initialSpringVelocity velocity: CGFloat) {
        UIView.animate(withDuration: duration,
                       delay: .zero,
                       usingSpringWithDamping: damping,
                       initialSpringVelocity: velocity) { [unowned self] in layoutIfNeeded() }
    }
    
    func animateUsingSpring(withDuration duration: TimeInterval,
                            withDamping damping: CGFloat,
                            initialSpringVelocity velocity: CGFloat,
                            animations: @escaping () -> Void) {
        UIView.animate(withDuration: duration,
                       delay: .zero,
                       usingSpringWithDamping: damping,
                       initialSpringVelocity: velocity,
                       animations: animations,
                       completion: nil)
    }
}

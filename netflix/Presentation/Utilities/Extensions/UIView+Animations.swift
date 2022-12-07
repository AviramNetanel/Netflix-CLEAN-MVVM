//
//  UIView+Animations.swift
//  netflix
//
//  Created by Zach Bazov on 19/09/2022.
//

import UIKit

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

extension UIView {
    fileprivate var defaultAnimationDuration: TimeInterval { return 0.3 }
    fileprivate var semiTransparent: CGFloat { return 0.5 }
    fileprivate var nonTransparent: CGFloat { return 1.0 }
    
    func setAlphaAnimation(using gesture: UIGestureRecognizer? = nil,
                           duration: TimeInterval? = nil,
                           alpha: CGFloat? = nil,
                           completion: @escaping () -> Void) {
        guard let gesture = gesture else { return }
        UIView.animate(withDuration: duration ?? defaultAnimationDuration) { [weak self] in
            guard let self = self else { return }
            self.alpha = alpha ?? self.semiTransparent
            self.isUserInteractionEnabled = false
        }
        if gesture.state == .ended {
            UIView.animate(withDuration: duration ?? defaultAnimationDuration) { [weak self] in
                guard let self = self else { return }
                self.alpha = alpha ?? self.nonTransparent
                self.isUserInteractionEnabled = true
                completion()
            }
        }
    }
}

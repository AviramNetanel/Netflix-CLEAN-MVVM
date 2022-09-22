//
//  UIView+Constraints.swift
//  netflix
//
//  Created by Zach Bazov on 22/09/2022.
//

import UIKit

// MARK: - UIView + Constraints

extension UIView {
    func constraintToSuperview(_ view: UIView) {
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func constraintToCenter(_ view: UIView) {
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: centerXAnchor),
            view.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

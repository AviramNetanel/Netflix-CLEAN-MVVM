//
//  UIButton+SetLayerBorder.swift
//  netflix
//
//  Created by Zach Bazov on 05/09/2022.
//

import UIKit

// MARK: - UIButton + SetLayerBorder

extension UIButton {
    func setLayerBorder(_ color: UIColor, width: CGFloat) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
}

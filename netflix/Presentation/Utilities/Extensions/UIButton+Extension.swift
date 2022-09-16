//
//  UIButton+Extension.swift
//  netflix
//
//  Created by Zach Bazov on 05/09/2022.
//

import UIKit

// MARK: - UIButton + Set Layer Border

extension UIButton {
    func setLayerBorder(_ color: UIColor, width: CGFloat) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
}

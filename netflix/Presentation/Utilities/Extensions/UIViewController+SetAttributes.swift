//
//  UIViewController+SetAttributes.swift
//  netflix
//
//  Created by Zach Bazov on 05/09/2022.
//

import UIKit

// MARK: - UIViewController + SetAttributes

extension UIViewController {
    func setAttributes(for fields: [UITextField]) {
        for field in fields {
            field.setPlaceholderAtrributes(string: field.placeholder ?? .init(), attributes: NSAttributedString.placeholderAttributes)
        }
    }
}

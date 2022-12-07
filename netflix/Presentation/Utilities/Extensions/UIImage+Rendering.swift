//
//  UIImage+Rendering.swift
//  netflix
//
//  Created by Zach Bazov on 19/09/2022.
//

import UIKit

extension UIImage {
    func whiteRendering(with symbolConfiguration: UIImage.SymbolConfiguration? = nil) -> UIImage? {
        return self
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(.white)
            .withConfiguration(symbolConfiguration ?? .unspecified)
    }
}

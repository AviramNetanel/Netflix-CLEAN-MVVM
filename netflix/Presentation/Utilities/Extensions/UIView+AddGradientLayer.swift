//
//  UIView+AddGradientLayer.swift
//  netflix
//
//  Created by Zach Bazov on 05/09/2022.
//

import UIKit

// MARK: - UIView + addGradientLayer

extension UIView {
    
    func addGradientLayer(frame: CGRect,
                          colors: [UIColor],
                          locations: [NSNumber],
                          points: [CGPoint]? = nil) {
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = colors.map { $0.cgColor }
        gradient.locations = locations
        gradient.type = .axial
        
        if let points = points {
            gradient.startPoint = points.first!
            gradient.endPoint = points.last!
        }
        
        self.layer.addSublayer(gradient)
    }
}

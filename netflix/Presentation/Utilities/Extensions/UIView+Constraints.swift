//
//  UIView+Constraints.swift
//  netflix
//
//  Created by Zach Bazov on 22/09/2022.
//

import UIKit

extension UIView {
    func constraintToSuperview(_ view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func constraintToCenter(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: centerXAnchor),
            view.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func constraintBottom(toParent view: UIView,
                          withHeightAnchor anchorValue: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomAnchor.constraint(equalTo: view.bottomAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            heightAnchor.constraint(equalToConstant: anchorValue)
        ])
    }
    
    func constraintBottom(toParent view: UIView,
                          withLeadingAnchor value: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: value),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func chainConstraintToCenter(linking aView: UIView,
                                 to bView: UIView,
                                 withTopAnchor topAnchorValue: CGFloat? = 8.0,
                                 withBottomAnchor bottomAnchorValue: CGFloat? = 8.0,
                                 withWidth widthValue: CGFloat? = 24.0,
                                 withHeight heightValue: CGFloat? = 24.0) {
        aView.translatesAutoresizingMaskIntoConstraints = false
        bView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            aView.topAnchor.constraint(equalTo: topAnchor, constant: topAnchorValue!),
            aView.centerXAnchor.constraint(equalTo: centerXAnchor),
            aView.widthAnchor.constraint(equalToConstant: widthValue!),
            aView.heightAnchor.constraint(equalToConstant: heightValue!),
            aView.bottomAnchor.constraint(equalTo: bView.topAnchor),
            
            bView.centerXAnchor.constraint(equalTo: centerXAnchor),
            bView.centerYAnchor.constraint(equalTo: centerYAnchor),
            bView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomAnchorValue!)
            
        ])
    }
    
    func chainConstraintToSuperview(linking aView: UIView,
                                    to bView: UIView,
                                    withWidthAnchor constraint: NSLayoutConstraint) {
        aView.translatesAutoresizingMaskIntoConstraints = false
        bView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            aView.topAnchor.constraint(equalTo: topAnchor, constant: 4.0),
            aView.leadingAnchor.constraint(equalTo: leadingAnchor),
            constraint,
            aView.heightAnchor.constraint(equalToConstant: 3.0),
            
            bView.topAnchor.constraint(equalTo: aView.bottomAnchor),
            bView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

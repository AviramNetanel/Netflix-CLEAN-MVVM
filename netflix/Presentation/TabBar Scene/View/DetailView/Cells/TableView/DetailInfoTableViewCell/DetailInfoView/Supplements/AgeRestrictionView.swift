//
//  AgeRestrictionView.swift
//  netflix
//
//  Created by Zach Bazov on 04/10/2022.
//

import UIKit

// MARK: - AgeRestrictionView class

final class AgeRestrictionView: UIView {
    
    private lazy var label: UILabel = {
        let label = UILabel(frame: bounds)
        label.font = UIFont.systemFont(ofSize: 11.0, weight: .heavy)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "PG-13"
        return label
    }()
    
    static func create(with frame: CGRect) -> AgeRestrictionView {
        let view = AgeRestrictionView(frame: frame)
        view.layer.cornerRadius = 2.0
        view.backgroundColor = .hexColor("#535353")
        view.addSubview(view.label)
        return view
    }
}

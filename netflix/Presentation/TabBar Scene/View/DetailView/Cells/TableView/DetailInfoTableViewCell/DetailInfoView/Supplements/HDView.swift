//
//  HDView.swift
//  netflix
//
//  Created by Zach Bazov on 04/10/2022.
//

import UIKit

// MARK: - HDView class

final class HDView: UIView {
    
    private lazy var label: UILabel = {
        let label = UILabel(frame: bounds)
        label.font = UIFont.systemFont(ofSize: 11.0, weight: .heavy)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "HD"
        return label
    }()
    
    static func create(with frame: CGRect) -> HDView {
        let view = HDView(frame: frame)
        view.layer.cornerRadius = 2.0
        view.backgroundColor = .hexColor("#414141")
        view.addSubview(view.label)
        return view
    }
}

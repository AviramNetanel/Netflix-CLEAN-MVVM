//
//  HDView.swift
//  netflix
//
//  Created by Zach Bazov on 04/10/2022.
//

import UIKit

// MARK: - ViewInput protocol

private protocol ViewInput {
    func viewDidLoad()
}

// MARK: - ViewOutput protocol

private protocol ViewOutput {
    var label: UILabel { get }
}

// MARK: - View typealias

private typealias View = ViewInput & ViewOutput

// MARK: - HDView class

final class HDView: UIView, View {
    
    fileprivate lazy var label: UILabel = {
        let label = UILabel(frame: bounds)
        label.font = UIFont.systemFont(ofSize: 11.0, weight: .heavy)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "HD"
        return label
    }()
    
    static func create(with frame: CGRect) -> HDView {
        let view = HDView(frame: frame)
        view.addSubview(view.label)
        view.viewDidLoad()
        return view
    }
    
    fileprivate func viewDidLoad() { setupSubviews() }
    
    private func setupSubviews() {
        layer.cornerRadius = 2.0
        backgroundColor = .hexColor("#414141")
    }
}

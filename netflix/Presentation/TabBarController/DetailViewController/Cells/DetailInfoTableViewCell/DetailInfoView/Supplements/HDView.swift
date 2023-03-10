//
//  HDView.swift
//  netflix
//
//  Created by Zach Bazov on 04/10/2022.
//

import UIKit

final class HDView: UIView {
    private lazy var label = createLabel()
    
    init(on parent: UIView) {
        super.init(frame: parent.bounds)
        parent.addSubview(self)
        self.addSubview(self.label)
        self.viewDidConfigure()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func createLabel() -> UILabel {
        let label = UILabel(frame: bounds)
        label.font = UIFont.systemFont(ofSize: 11.0, weight: .heavy)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "HD"
        return label
    }
    
    private func viewDidConfigure() {
        layer.cornerRadius = 2.0
        backgroundColor = .hexColor("#414141")
    }
}

//
//  DetailInfoView.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit

// MARK: - DetailInfoView class

final class DetailInfoView: UIView, ViewInstantiable {
    
    static func create(on parent: UIView) -> DetailInfoView {
        let view = DetailInfoView(frame: parent.bounds)
        view.nibDidLoad()
        view.backgroundColor = .black
        return view
    }
}

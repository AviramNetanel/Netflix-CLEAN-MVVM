//
//  DetailDescriptionView.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit

// MARK: - DetailDescriptionView class

final class DetailDescriptionView: UIView, ViewInstantiable {
    
    static func create(on parent: UIView) -> DetailDescriptionView {
        let view = DetailDescriptionView(frame: parent.bounds)
        view.nibDidLoad()
        view.backgroundColor = .black
        return view
    }
}

//
//  DetailNavigationView.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit

// MARK: - DetailNavigationView class

final class DetailNavigationView: UIView, ViewInstantiable {
    
    static func create(on parent: UIView) -> DetailNavigationView {
        let view = DetailNavigationView(frame: parent.bounds)
        view.nibDidLoad()
        view.backgroundColor = .black
        return view
    }
}

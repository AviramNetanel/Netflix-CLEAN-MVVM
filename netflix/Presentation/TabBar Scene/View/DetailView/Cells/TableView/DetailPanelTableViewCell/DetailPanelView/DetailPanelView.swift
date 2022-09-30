//
//  DetailPanelView.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit

// MARK: - DetailPanelView class

final class DetailPanelView: UIView, ViewInstantiable {
    
    static func create(on parent: UIView) -> DetailPanelView {
        let view = DetailPanelView(frame: parent.bounds)
        view.nibDidLoad()
        view.backgroundColor = .black
        return view
    }
}

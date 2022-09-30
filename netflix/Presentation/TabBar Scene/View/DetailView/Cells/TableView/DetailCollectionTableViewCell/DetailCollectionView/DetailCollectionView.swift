//
//  DetailCollectionView.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit

// MARK: - DetailCollectionView class

final class DetailCollectionView: UIView {
    
    static func create(on parent: UIView) -> DetailCollectionView {
        let view = DetailCollectionView(frame: parent.bounds)
        view.setupSubviews()
        return view
    }
    
    private func setupSubviews() {
        backgroundColor = .red
    }
}

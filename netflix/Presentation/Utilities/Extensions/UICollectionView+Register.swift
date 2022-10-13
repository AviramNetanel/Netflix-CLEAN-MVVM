//
//  UICollectionView+Register.swift
//  netflix
//
//  Created by Zach Bazov on 12/10/2022.
//

import UIKit

// MARK: - UICollectionView + Register

extension UICollectionView {
    
    func registerNib(_ views: UIView.Type...) {
        views.forEach {
            let nib = UINib(nibName: String(describing: $0), bundle: nil)
            register(nib, forCellWithReuseIdentifier: String(describing: $0))
        }
    }
}

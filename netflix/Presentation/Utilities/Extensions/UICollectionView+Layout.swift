//
//  UICollectionView+Layout.swift
//  netflix
//
//  Created by Zach Bazov on 04/10/2022.
//

import UIKit

// MARK: - UICollectionView + Layout

extension UICollectionView {
    func setCollectionViewLayout(layout: CollectionViewLayout.Layout) {
        switch layout {
        case .ratable:
            let configuration = CollectionViewLayout.ratableConfigurations(for: self)
            let layout = CollectionViewLayout(configuration: configuration)
            setCollectionViewLayout(layout, animated: false)
        case .resumable:
            let configuration = CollectionViewLayout.standardConfigurations(for: self)
            let layout = CollectionViewLayout(configuration: configuration)
            setCollectionViewLayout(layout, animated: false)
        case .standard:
            let configuration = CollectionViewLayout.standardConfigurations(for: self)
            let layout = CollectionViewLayout(configuration: configuration)
            setCollectionViewLayout(layout, animated: false)
        case .categoriesOverlay:
            let configuration = CollectionViewLayout.categoriesOverlayConfigurations(for: self)
            let layout = CollectionViewLayout(configuration: configuration)
            setCollectionViewLayout(layout, animated: false)
        case .detailCollection:
            let configuration = CollectionViewLayout.detailCollectionConfigurations(for: self)
            let layout = CollectionViewLayout(configuration: configuration)
            setCollectionViewLayout(layout, animated: false)
        }
    }
}

//
//  UICollectionView+Layout.swift
//  netflix
//
//  Created by Zach Bazov on 04/10/2022.
//

import UIKit

// MARK: - UICollectionView + Layout

extension UICollectionView {
    func setCollectionViewLayout(layout: DefaultCollectionViewLayout.Layout) {
        switch layout {
        case .ratable:
            let configuration = DefaultCollectionViewLayout.ratableConfigurations(for: self)
            let layout = DefaultCollectionViewLayout(configuration: configuration)
            setCollectionViewLayout(layout, animated: false)
        case .resumable:
            let configuration = DefaultCollectionViewLayout.standardConfigurations(for: self)
            let layout = DefaultCollectionViewLayout(configuration: configuration)
            setCollectionViewLayout(layout, animated: false)
        case .standard:
            let configuration = DefaultCollectionViewLayout.standardConfigurations(for: self)
            let layout = DefaultCollectionViewLayout(configuration: configuration)
            setCollectionViewLayout(layout, animated: false)
        case .categoriesOverlay:
            let configuration = DefaultCollectionViewLayout.categoriesOverlayConfigurations(for: self)
            let layout = DefaultCollectionViewLayout(configuration: configuration)
            setCollectionViewLayout(layout, animated: false)
        case .detailCollection:
            let configuration = DefaultCollectionViewLayout.detailCollectionConfigurations(for: self)
            let layout = DefaultCollectionViewLayout(configuration: configuration)
            setCollectionViewLayout(layout, animated: false)
        }
    }
}

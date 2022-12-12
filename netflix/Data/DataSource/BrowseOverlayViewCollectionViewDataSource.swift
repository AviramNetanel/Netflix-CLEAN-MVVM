//
//  BrowseOverlayViewCollectionViewDataSource.swift
//  netflix
//
//  Created by Zach Bazov on 07/12/2022.
//

import UIKit.UICollectionView

final class BrowseOverlayViewCollectionViewDataSource: NSObject,
                                                       UICollectionViewDelegate,
                                                       UICollectionViewDataSource {
    private let coordinator: HomeViewCoordinator
    private let section: Section
    private let items: [Media]
    
    init(section: Section, with viewModel: HomeViewModel) {
        self.coordinator = viewModel.coordinator!
        self.section = section
        self.items = section.media
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return StandardCollectionViewCell.create(
            on: collectionView,
            reuseIdentifier: StandardCollectionViewCell.reuseIdentifier,
            section: section,
            for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let media = items[indexPath.row]
        coordinator.presentMediaDetails(in: section, for: media, shouldScreenRoatate: false)
    }
}

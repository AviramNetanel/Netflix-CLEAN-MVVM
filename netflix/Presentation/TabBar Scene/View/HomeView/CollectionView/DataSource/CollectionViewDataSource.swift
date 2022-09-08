//
//  CollectionViewDataSource.swift
//  netflix
//
//  Created by Zach Bazov on 08/09/2022.
//

import UIKit

// MARK: - CollectionViewDataSourceInput protocol

protocol CollectionViewDataSourceInput {
    func willDisplay(cell: CollectionViewCell,
                     forItemAt indexPath: IndexPath)
    func didEndDisplaying(cell: CollectionViewCell,
                          forItemAt indexPath: IndexPath)
}

// MARK: - CollectionViewDataSourceOutput protocol

protocol CollectionViewDataSourceOutput {
    var section: Section { get }
}

// MARK: - CollectionViewDataSource protocol

protocol CollectionViewDataSource: CollectionViewDataSourceInput, CollectionViewDataSourceOutput {}

// MARK: - DefaultCollectionViewDataSource class + UICollectionView conformances

final class DefaultCollectionViewDataSource<Cell>: NSObject,
                                                   UICollectionViewDelegate,
                                                   UICollectionViewDataSource,
                                                   UICollectionViewDataSourcePrefetching where Cell: Configurable {
    
    var section: Section
    
    init(section: Section) {
        self.section = section
    }
    
    // MARK: UITableViewDelegate
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        willDisplay(cell: cell as! CollectionViewCell, forItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        didEndDisplaying(cell: cell as! CollectionViewCell, forItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
    }
    
    // MARK: UITableViewDataSource
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.section.tvshows?.count ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return DefaultCollectionViewCell.create(collectionView: collectionView,
                                                section: section,
                                                reuseIdentifier: Cell.reuseIdentifier,
                                                at: indexPath)
    }
    
    // MARK: UITableViewDataSourcePrefetching
    
    func collectionView(_ collectionView: UICollectionView,
                        prefetchItemsAt indexPaths: [IndexPath]) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        
    }
}

// MARK: - CollectionViewDataSource implementation

extension DefaultCollectionViewDataSource: CollectionViewDataSource {
    
    func willDisplay(cell: CollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func didEndDisplaying(cell: CollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
}

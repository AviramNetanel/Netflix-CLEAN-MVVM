//
//  CollectionViewDataSource.swift
//  netflix
//
//  Created by Zach Bazov on 08/09/2022.
//

import UIKit

protocol CollectionViewDataSourceInput {
    
    func willDisplay(cell: CollectionViewCell, forItemAt indexPath: IndexPath)
    
    func didEndDisplaying(cell: CollectionViewCell, forItemAt indexPath: IndexPath)
}

protocol CollectionViewDataSourceOutput {
    var section: Section { get }
}

protocol CollectionViewDataSource: CollectionViewDataSourceInput, CollectionViewDataSourceOutput {}

final class DefaultCollectionViewDataSource: NSObject {
    
    var section: Section
    
    init(section: Section) {
        self.section = section
    }
}

extension DefaultCollectionViewDataSource: UICollectionViewDelegate,
                                           UICollectionViewDataSource,
                                           UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.section.tvshows?.count ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RatableCollectionViewCell.reuseIdentifier, for: indexPath) as? RatableCollectionViewCell else {
            fatalError("Could not dequeue cell \(RatableCollectionViewCell.self) with reuseIdentifier: \(RatableCollectionViewCell.reuseIdentifier)")
        }
        cell.configure(with: CollectionViewCellItemViewModel(media: self.section.tvshows![indexPath.row]))
        return cell
    }
    
    //
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        willDisplay(cell: cell as! CollectionViewCell, forItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        didEndDisplaying(cell: cell as! CollectionViewCell, forItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    //
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        
    }
}

extension DefaultCollectionViewDataSource: CollectionViewDataSource {
    
    func willDisplay(cell: CollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func didEndDisplaying(cell: CollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
}

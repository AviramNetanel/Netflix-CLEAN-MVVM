//
//  CollectionViewDataSource.swift
//  netflix
//
//  Created by Zach Bazov on 08/09/2022.
//

import UIKit

// MARK: - CollectionViewDataSourceInput protocol

protocol CollectionViewDataSourceInput {
    func willDisplay(cell: CollectionViewCell, forItemAt indexPath: IndexPath)
    func didEndDisplaying(cell: CollectionViewCell, forItemAt indexPath: IndexPath)
}

// MARK: - CollectionViewDataSourceOutput protocol

protocol CollectionViewDataSourceOutput {
    var section: Section { get }
}

// MARK: - CollectionViewDataSource protocol

protocol CollectionViewDataSource: CollectionViewDataSourceInput, CollectionViewDataSourceOutput {}

// MARK: - DefaultCollectionViewDataSource class

final class DefaultCollectionViewDataSource: NSObject {
    
    var section: Section
    
    init(section: Section) {
        self.section = section
    }
}

// MARK: - CollectionViewDataSource implementation

extension DefaultCollectionViewDataSource: CollectionViewDataSource {
    
    func willDisplay(cell: CollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func didEndDisplaying(cell: CollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource and UITableViewDataSourcePrefetching implementation

extension DefaultCollectionViewDataSource: UICollectionViewDelegate,
                                           UICollectionViewDataSource,
                                           UICollectionViewDataSourcePrefetching {
    
    // MARK: UITableViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        willDisplay(cell: cell as! CollectionViewCell, forItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        didEndDisplaying(cell: cell as! CollectionViewCell, forItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    // MARK: UITableViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.section.tvshows?.count ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let indices = SectionIndices(rawValue: indexPath.section) else {
            fatalError("Unexpected collection view data source index \(indexPath.section)")
        }
        switch indices {
        case .ratable:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RatableCollectionViewCell.reuseIdentifier,
                for: indexPath) as? RatableCollectionViewCell
            else {
                fatalError("Could not dequeue cell \(RatableCollectionViewCell.self) with reuseIdentifier: \(RatableCollectionViewCell.reuseIdentifier)")
            }
            let viewModel = CollectionViewCellItemViewModel(media: self.section.tvshows![indexPath.row])
            cell.configure(with: viewModel)
            return cell
        case .resumable:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ResumableCollectionViewCell.reuseIdentifier,
                for: indexPath) as? ResumableCollectionViewCell
            else {
                fatalError("Could not dequeue cell \(ResumableCollectionViewCell.self) with reuseIdentifier: \(ResumableCollectionViewCell.reuseIdentifier)")
            }
            let viewModel = CollectionViewCellItemViewModel(media: self.section.tvshows![indexPath.row])
            cell.configure(with: viewModel)
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: StandardCollectionViewCell.reuseIdentifier,
                for: indexPath) as? StandardCollectionViewCell
            else {
                fatalError("Could not dequeue cell \(StandardCollectionViewCell.self) with reuseIdentifier: \(StandardCollectionViewCell.reuseIdentifier)")
            }
            let viewModel = CollectionViewCellItemViewModel(media: self.section.tvshows![indexPath.row])
            cell.configure(with: viewModel)
            return cell
        }
    }
    
    // MARK: UITableViewDataSourcePrefetching
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        
    }
}

//
//  DetailCollectionViewDataSource.swift
//  netflix
//
//  Created by Zach Bazov on 04/10/2022.
//

import UIKit

// MARK: - DetailCollectionViewDataSourceDependencies protocol

protocol DetailCollectionViewDataSourceDependencies {
    func createDetailCollectionViewDataSource(on collectionView: UICollectionView, with items: [Mediable]) -> DetailCollectionViewDataSource<Mediable>
}

// MARK: - DataSourceInput protocol

private protocol DataSourceInput {}

// MARK: - DataSourceOutput protocol

private protocol DataSourceOutput {
    associatedtype T
    var items: [T] { get }
    var collectionView: UICollectionView { get }
    var numberOfSections: Int { get }
    var cache: NSCache<NSString, UIImage> { get }
}

// MARK: - DataSource typealias

private typealias DataSource = DataSourceInput & DataSourceOutput

// MARK: - DetailCollectionViewDataSource class

final class DetailCollectionViewDataSource<T>: NSObject,
                                               DataSource,
                                               UICollectionViewDelegate,
                                               UICollectionViewDataSource,
                                               UICollectionViewDataSourcePrefetching {
    
    private let diProvider: DetailViewDIProvider
    fileprivate let numberOfSections = 1
    fileprivate let collectionView: UICollectionView
    let items: [T]
    fileprivate var cache: NSCache<NSString, UIImage> { AsyncImageFetcher.shared.cache }
    
    init(using diProvider: DetailViewDIProvider, collectionView: UICollectionView, items: [T]) {
        self.collectionView = collectionView
        self.items = items
        self.diProvider = diProvider
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch diProvider.dependencies.detailViewModel.navigationViewState.value {
        case .episodes:
            return EpisodeCollectionViewCell.create(on: collectionView, for: indexPath, with: diProvider.dependencies.detailViewModel)
        case .trailers:
            return TrailerCollectionViewCell.create(on: collectionView, for: indexPath, with: diProvider.dependencies.detailViewModel.dependencies.media)
        default:
            return CollectionViewCell.create(on: collectionView,
                                             reuseIdentifier: StandardCollectionViewCell.reuseIdentifier,
                                             section: diProvider.dependencies.detailViewModel.dependencies.section,
                                             for: indexPath,
                                             with: diProvider.dependencies.detailViewModel.homeDataSourceState)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {}
}

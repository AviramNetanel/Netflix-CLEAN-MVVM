//
//  DetailCollectionViewDataSource.swift
//  netflix
//
//  Created by Zach Bazov on 04/10/2022.
//

import UIKit

// MARK: - DataSourceInput protocol

private protocol DataSourceInput {}

// MARK: - DataSourceOutput protocol

private protocol DataSourceOutput {
    associatedtype T
    var items: [T]! { get }
    var collectionView: UICollectionView! { get }
    var viewModel: DetailViewModel! { get }
    var numberOfSections: Int { get }
    var cache: NSCache<NSString, UIImage> { get }
}

// MARK: - DataSourcing typealias

private typealias DataSourcing = DataSourceInput & DataSourceOutput

// MARK: - DetailCollectionViewDataSource class

final class DetailCollectionViewDataSource<T>: NSObject,
                                               DataSourcing,
                                               UICollectionViewDelegate,
                                               UICollectionViewDataSource,
                                               UICollectionViewDataSourcePrefetching {
    
    fileprivate let numberOfSections = 1
    fileprivate(set) var items: [T]!
    fileprivate var collectionView: UICollectionView!
    fileprivate var viewModel: DetailViewModel!
    fileprivate var cache: NSCache<NSString, UIImage> { AsyncImageFetcher.shared.cache }
    
    deinit {
        items = nil
        collectionView = nil
        viewModel = nil
    }
    
    static func create(on collectionView: UICollectionView,
                       items: [T],
                       with viewModel: DetailViewModel) -> DetailCollectionViewDataSource {
        let dataSource = DetailCollectionViewDataSource()
        dataSource.collectionView = collectionView
        dataSource.items = items
        dataSource.viewModel = viewModel
        return dataSource
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { numberOfSections }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int { items.count }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel.navigationViewState.value {
        case .episodes:
            return EpisodeCollectionViewCell.create(on: collectionView,
                                                    for: indexPath,
                                                    with: viewModel)
        case .trailers:
            return TrailerCollectionViewCell.create(on: collectionView,
                                                    for: indexPath,
                                                    with: viewModel.dependencies.media)
        default:
            return CollectionViewCell.create(on: collectionView,
                                             reuseIdentifier: StandardCollectionViewCell.reuseIdentifier,
                                             section: viewModel.dependencies.section,
                                             for: indexPath,
                                             with: viewModel.state)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {}
    
    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {}
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {}
    
    func collectionView(_ collectionView: UICollectionView,
                        prefetchItemsAt indexPaths: [IndexPath]) {}
}

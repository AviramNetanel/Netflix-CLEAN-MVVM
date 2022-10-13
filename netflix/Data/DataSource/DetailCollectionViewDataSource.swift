//
//  DetailCollectionViewDataSource.swift
//  netflix
//
//  Created by Zach Bazov on 04/10/2022.
//

import UIKit

// MARK: - DataSourcingInput protocol

private protocol DataSourcingInput {}

// MARK: - DataSourcingOutput protocol

private protocol DataSourcingOutput {
    var collectionView: UICollectionView { get }
    var viewModel: DetailViewModel { get }
    var numberOfSections: Int { get }
}

// MARK: - DataSourcing typealias

private typealias DataSourcing = DataSourcingInput & DataSourcingOutput

// MARK: - DetailCollectionViewDataSource class

final class DetailCollectionViewDataSource<T>: NSObject,
                                               DataSourcing,
                                               UICollectionViewDelegate,
                                               UICollectionViewDataSource,
                                               UICollectionViewDataSourcePrefetching {
    
    fileprivate var collectionView: UICollectionView
    fileprivate(set) var items: [T]
    fileprivate var viewModel: DetailViewModel
    fileprivate let numberOfSections = 1
    
    private var cache: NSCache<NSString, UIImage> { AsyncImageFetcher.shared.cache }
    
    init(collectionView: UICollectionView,
         items: [T],
         with viewModel: DetailViewModel) {
        self.collectionView = collectionView
        self.items = items
        self.viewModel = viewModel
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { numberOfSections }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int { items.count }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel.navigationViewState.value {
        case .episodes:
            return EpisodeCollectionViewCell.create(in: collectionView,
                                                    for: indexPath,
                                                    with: viewModel)
        case .trailers:
            return TrailerCollectionViewCell.create(in: collectionView,
                                                    for: indexPath,
                                                    with: viewModel.media)
        default:
            return CollectionViewCell.create(in: collectionView,
                                             reuseIdentifier: StandardCollectionViewCell.reuseIdentifier,
                                             section: viewModel.section,
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

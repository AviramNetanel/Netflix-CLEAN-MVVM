//
//  DetailCollectionViewDataSource.swift
//  netflix
//
//  Created by Zach Bazov on 04/10/2022.
//

import UIKit

private protocol DataSourceInput {}

private protocol DataSourceOutput {
    associatedtype T
    var items: [T] { get }
    var collectionView: UICollectionView { get }
    var numberOfSections: Int { get }
    var cache: NSCache<NSString, UIImage> { get }
}

private typealias DataSource = DataSourceInput & DataSourceOutput

final class DetailCollectionViewDataSource<T>: NSObject,
                                               DataSource,
                                               UICollectionViewDelegate,
                                               UICollectionViewDataSource {
    private let viewModel: DetailViewModel
    fileprivate let numberOfSections = 1
    fileprivate let collectionView: UICollectionView
    let items: [T]
    fileprivate var cache: NSCache<NSString, UIImage> { AsyncImageFetcher.shared.cache }
    
    init(collectionView: UICollectionView, items: [T], with viewModel: DetailViewModel) {
        self.viewModel = viewModel
        self.collectionView = collectionView
        self.items = items
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel.navigationViewState.value {
        case .episodes:
            return EpisodeCollectionViewCell.create(on: collectionView, for: indexPath, with: viewModel)
        case .trailers:
            return TrailerCollectionViewCell.create(on: collectionView, for: indexPath, with: viewModel)
        default:
            return CollectionViewCell.create(on: collectionView,
                                             reuseIdentifier: StandardCollectionViewCell.reuseIdentifier,
                                             section: viewModel.section,
                                             for: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
}

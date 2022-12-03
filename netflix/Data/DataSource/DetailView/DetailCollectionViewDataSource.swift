//
//  DetailCollectionViewDataSource.swift
//  netflix
//
//  Created by Zach Bazov on 04/10/2022.
//

import UIKit

// MARK: - DetailCollectionViewDataSourceDependencies protocol

protocol DetailCollectionViewDataSourceDependencies {
    func createDetailCollectionViewDataSource(
        on collectionView: UICollectionView,
        with items: [Mediable]) -> DetailCollectionViewDataSource<Mediable>
    func createEpisodeCollectionViewCell(
        on collectionView: UICollectionView,
        for indexPath: IndexPath) -> EpisodeCollectionViewCell
    func createEpisodeCollectionViewCellViewModel() -> EpisodeCollectionViewCellViewModel
    func createTrailerCollectionViewCell(
        on collectionView: UICollectionView,
        for indexPath: IndexPath) -> TrailerCollectionViewCell
    func createTrailerCollectionViewCellViewModel() -> TrailerCollectionViewCellViewModel
    func createCollectionViewCell(
        on collectionView: UICollectionView,
        reuseIdentifier: String,
        section: Section,
        for indexPath: IndexPath) -> CollectionViewCell
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
                                               UICollectionViewDataSource {
    
    private let diProvider: DetailViewDIProvider
    fileprivate let numberOfSections = 1
    fileprivate let collectionView: UICollectionView
    let items: [T]
    fileprivate var cache: NSCache<NSString, UIImage> { AsyncImageFetcher.shared.cache }
    
    init(using diProvider: DetailViewDIProvider,
         collectionView: UICollectionView,
         items: [T]) {
        self.diProvider = diProvider
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
        switch diProvider.dependencies.detailViewModel.navigationViewState.value {
        case .episodes:
            return diProvider.createEpisodeCollectionViewCell(on: collectionView, for: indexPath)
        case .trailers:
            return diProvider.createTrailerCollectionViewCell(on: collectionView, for: indexPath)
        default:
            return diProvider.createCollectionViewCell(
                on: collectionView,
                reuseIdentifier: StandardCollectionViewCell.reuseIdentifier,
                section: diProvider.dependencies.detailViewModel.dependencies.section,
                for: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

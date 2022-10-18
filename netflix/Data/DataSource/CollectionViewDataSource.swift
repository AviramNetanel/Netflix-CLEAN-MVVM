//
//  CollectionViewDataSource.swift
//  netflix
//
//  Created by Zach Bazov on 13/09/2022.
//

import UIKit

// MARK: - DataSourceInput protocol

private protocol DataSourceInput {
    func viewDidLoad()
    func dataSourceDidChange()
    func media(for indexPath: IndexPath) -> Media?
    var didSelectItem: ((IndexPath.Element) -> Void)? { get }
}

// MARK: - DataSourceOutput protocol

private protocol DataSourceOutput {
    var collectionView: UICollectionView! { get }
    var section: Section! { get }
    var viewModel: HomeViewModel! { get }
    var cache: NSCache<NSString, UIImage> { get }
}

// MARK: - DataSourcing protocol

private typealias DataSourcing = DataSourceInput & DataSourceOutput

// MARK: - CollectionViewDataSource class

final class CollectionViewDataSource<Cell>: NSObject,
                                            DataSourcing,
                                            UICollectionViewDelegate,
                                            UICollectionViewDataSource,
                                            UICollectionViewDataSourcePrefetching where Cell: UICollectionViewCell {
    
    fileprivate weak var collectionView: UICollectionView!
    fileprivate var section: Section!
    fileprivate var viewModel: HomeViewModel!
    fileprivate var cache: NSCache<NSString, UIImage> { AsyncImageFetcher.shared.cache }
    
    var didSelectItem: ((Int) -> Void)?
    
    deinit {
        didSelectItem = nil
        section = nil
        collectionView = nil
        viewModel = nil
    }
    
    static func create(on collectionView: UICollectionView,
                       section: Section,
                       with viewModel: HomeViewModel) -> CollectionViewDataSource {
        let dataSource = CollectionViewDataSource()
        dataSource.section = section
        dataSource.viewModel = viewModel
        dataSource.collectionView = collectionView
        dataSource.viewDidLoad()
        return dataSource
    }
    
    fileprivate func viewDidLoad() { dataSourceDidChange() }
    
    fileprivate func dataSourceDidChange() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.reloadData()
    }
    
    fileprivate func media(for indexPath: IndexPath) -> Media? {
        return viewModel.state.value == .tvShows
            ? section.media[indexPath.row] as Media?
            : section.media[indexPath.row] as Media?
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.state.value == .tvShows
            ? self.section.media.count
            : self.section.media.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return CollectionViewCell.create(on: collectionView,
                                         reuseIdentifier: Cell.reuseIdentifier,
                                         section: section,
                                         for: indexPath,
                                         with: viewModel.state.value)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {}
    
    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {}
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        didSelectItem?(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        prefetchItemsAt indexPaths: [IndexPath]) {}
    
    func collectionView(_ collectionView: UICollectionView,
                        cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {}
}

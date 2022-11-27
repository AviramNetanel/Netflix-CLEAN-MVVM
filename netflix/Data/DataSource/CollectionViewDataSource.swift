//
//  CollectionViewDataSource.swift
//  netflix
//
//  Created by Zach Bazov on 13/09/2022.
//

import UIKit

// MARK: - CollectionViewDataSourceDependencies protocol

protocol CollectionViewDataSourceDepenendencies {
    func createHomeCollectionViewDataSourceActions(for section: Int,
                                                   using actions: HomeTableViewDataSourceActions) -> CollectionViewDataSourceActions
}

// MARK: - CollectionViewDataSourceActions struct

struct CollectionViewDataSourceActions {
    var didSelectItem: (Int) -> Void
}

// MARK: - DataSourceInput protocol

private protocol DataSourceInput {
    func viewDidLoad()
    func dataSourceDidChange()
}

// MARK: - DataSourceOutput protocol

private protocol DataSourceOutput {
    var collectionView: UICollectionView! { get }
    var actions: CollectionViewDataSourceActions? { get }
    var section: Section { get }
    var cache: NSCache<NSString, UIImage> { get }
}

// MARK: - DataSource protocol

private typealias DataSource = DataSourceInput & DataSourceOutput

// MARK: - CollectionViewDataSource class

final class CollectionViewDataSource<Cell>: NSObject,
                                            DataSource,
                                            UICollectionViewDelegate,
                                            UICollectionViewDataSource,
                                            UICollectionViewDataSourcePrefetching where Cell: UICollectionViewCell {
    
    fileprivate weak var collectionView: UICollectionView!
    fileprivate var actions: CollectionViewDataSourceActions?
    fileprivate var section: Section
    fileprivate var cache: NSCache<NSString, UIImage> { AsyncImageFetcher.shared.cache }
    fileprivate let homeViewModel: HomeViewModel
    
    init(on collectionView: UICollectionView,
         section: Section,
         viewModel: HomeViewModel,
         with actions: CollectionViewDataSourceActions? = nil) {
        self.actions = actions
        self.section = section
        self.collectionView = collectionView
        self.homeViewModel = viewModel
        super.init()
        self.viewDidLoad()
    }
    
    deinit {
        collectionView = nil
        actions = nil
    }
    
    fileprivate func viewDidLoad() { dataSourceDidChange() }
    
    fileprivate func dataSourceDidChange() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.section.media.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return CollectionViewCell.create(on: collectionView,
                                         reuseIdentifier: Cell.reuseIdentifier,
                                         section: section,
                                         for: indexPath,
                                         with: homeViewModel.tableViewState.value)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        actions?.didSelectItem(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {}
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {}
}

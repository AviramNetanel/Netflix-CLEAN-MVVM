//
//  HomeCollectionViewDataSource.swift
//  netflix
//
//  Created by Zach Bazov on 13/09/2022.
//

import UIKit

struct HomeCollectionViewDataSourceActions {
    var didSelectItem: (Int) -> Void
}

private protocol DataSourceInput {
    func viewDidLoad()
    func dataSourceDidChange()
}

private protocol DataSourceOutput {
    var collectionView: UICollectionView! { get }
    var actions: HomeCollectionViewDataSourceActions? { get }
    var section: Section { get }
//    var cache: NSCache<NSString, UIImage> { get }
}

private typealias DataSource = DataSourceInput & DataSourceOutput

final class HomeCollectionViewDataSource<Cell>: NSObject,
                                                DataSource,
                                                UICollectionViewDelegate,
                                                UICollectionViewDataSource,
                                                UICollectionViewDataSourcePrefetching where Cell: UICollectionViewCell {
    weak var collectionView: UICollectionView!
    var actions: HomeCollectionViewDataSourceActions?
    fileprivate var section: Section
//    fileprivate var cache: NSCache<NSString, UIImage> { AsyncImageFetcher.shared.cache }
    fileprivate let homeViewModel: HomeViewModel
//    var cell: CollectionViewCell!
    
    init(on collectionView: UICollectionView,
         section: Section,
         viewModel: HomeViewModel,
         with actions: HomeCollectionViewDataSourceActions? = nil) {
        self.actions = actions
        self.section = section
        self.collectionView = collectionView
        self.homeViewModel = viewModel
        super.init()
        self.viewDidLoad()
    }
    
    deinit {
        print("HomeCollectionViewDataSource")
//        cell?.representedIdentifier = nil
//        cell?.viewModel = nil
//        cell?.removeFromSuperview()
//        cell = nil
//        collectionView?.delegate = nil
//        collectionView?.dataSource = nil
//        collectionView?.removeFromSuperview()
        collectionView = nil
        actions = nil
    }
    
    fileprivate func viewDidLoad() {
        dataSourceDidChange()
    }
    
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
                                         for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        actions?.didSelectItem(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {}
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {}
}

//
//  DefaultCollectionViewDataSource.swift
//  netflix
//
//  Created by Zach Bazov on 13/09/2022.
//

import UIKit

// MARK: - CollectionViewDataSourceInput protocol

private protocol CollectionViewDataSourceInput {
    var collectionView: UICollectionView! { get }
    var section: Section { get }
}

// MARK: - CollectionViewDataSourceOutput protocol

private protocol CollectionViewDataSourceOutput {
    func dataSourceDidChange()
    func media(for indexPath: IndexPath) -> Media?
    
    var didSelectItem: ((IndexPath.Element) -> Void)? { get }
}

// MARK: - CollectionViewDataSource protocol

private protocol CollectionViewDataSource: CollectionViewDataSourceInput,
                                           CollectionViewDataSourceOutput {}

// MARK: - CollectionViewDataSource class

final class DefaultCollectionViewDataSource<Cell>: NSObject,
                                            CollectionViewDataSource,
                                            UICollectionViewDelegate,
                                            UICollectionViewDataSource,
                                            UICollectionViewDataSourcePrefetching where Cell: UICollectionViewCell {
    
    fileprivate weak var collectionView: UICollectionView!
    fileprivate var section: Section
    
    private var viewModel: DefaultHomeViewModel
    private var cache: NSCache<NSString, UIImage> { AsyncImageFetcher.shared.cache }
    
    var didSelectItem: ((Int) -> Void)?
    
    init(collectionView: UICollectionView,
         section: Section,
         viewModel: DefaultHomeViewModel) {
        self.collectionView = collectionView
        self.section = section
        self.viewModel = viewModel
        super.init()
        self.setupSubviews()
    }
    
    deinit {
        didSelectItem = nil
        collectionView = nil
    }
    
    private func setupSubviews() {
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        dataSourceDidChange()
    }
    
    fileprivate func dataSourceDidChange() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.reloadData()
    }
    
    fileprivate func media(for indexPath: IndexPath) -> Media? {
        return viewModel.state.value == .tvShows
            ? section.tvshows![indexPath.row] as Media?
            : section.movies![indexPath.row] as Media?
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.state.value == .tvShows
            ? self.section.tvshows!.count
            : self.section.movies!.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return DefaultCollectionViewCell.create(in: collectionView,
                                         reuseIdentifier: Cell.reuseIdentifier,
                                         section: section,
                                         for: indexPath,
                                         with: viewModel)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {}
    
    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {}
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) { didSelectItem?(indexPath.row) }
    
    func collectionView(_ collectionView: UICollectionView,
                        prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            guard let media = media(for: indexPath) else { fatalError() }
            let cellViewModel = DefaultCollectionViewCellItemViewModel(media: media,
                                                                indexPath: indexPath)
            DefaultCollectionViewCell.download(with: cellViewModel)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {}
}

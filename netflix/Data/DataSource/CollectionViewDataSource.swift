//
//  CollectionViewDataSource.swift
//  netflix
//
//  Created by Zach Bazov on 13/09/2022.
//

import UIKit

// MARK: - CollectionViewDataSource class

final class CollectionViewDataSource<Cell>: NSObject,
                                            UICollectionViewDelegate,
                                            UICollectionViewDataSource,
                                            UICollectionViewDataSourcePrefetching where Cell: UICollectionViewCell {
    
    private weak var collectionView: UICollectionView!
    private var section: Section
    private var viewModel: DefaultHomeViewModel
    
    private var standardCell: DefaultTableViewCell<Cell>!
    
    private var cache: NSCache<NSString, UIImage> { AsyncImageFetcher.shared.cache }
    
    init(collectionView: UICollectionView,
         section: Section,
         viewModel: DefaultHomeViewModel) {
        self.collectionView = collectionView
        self.section = section
        self.viewModel = viewModel
        super.init()
        self.setupSubviews()
    }
    
    convenience init(collectionView: UICollectionView,
                     section: Section,
                     viewModel: DefaultHomeViewModel,
                     standardCell: DefaultTableViewCell<Cell>) {
        self.init(collectionView: collectionView, section: section, viewModel: viewModel)
        self.standardCell = standardCell
        self.setupSubviews()
    }
    
    deinit {
        standardCell = nil
    }
    
    func setupSubviews() {
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        dataSourceDidChange()
    }
    
    private func dataSourceDidChange() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.reloadData()
    }
    
    private func media(for indexPath: IndexPath) -> Media? {
        return viewModel.state.value == .tvShows
            ? viewModel.sections.value[indexPath.section].tvshows![indexPath.row] as Media?
            : viewModel.sections.value[indexPath.section].movies![indexPath.row] as Media?
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.state.value == .tvShows
            ? viewModel.sections.value[section].tvshows!.count
            : viewModel.sections.value[section].movies!.count
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
                        didSelectItemAt indexPath: IndexPath) {}
    
    func collectionView(_ collectionView: UICollectionView,
                        prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            guard let media = media(for: indexPath) else { fatalError() }
            let cellViewModel = CollectionViewCellItemViewModel(media: media,
                                                                indexPath: indexPath)
            DefaultCollectionViewCell.download(with: cellViewModel)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {}
}

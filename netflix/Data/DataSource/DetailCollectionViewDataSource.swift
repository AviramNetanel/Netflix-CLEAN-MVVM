//
//  DetailCollectionViewDataSource.swift
//  netflix
//
//  Created by Zach Bazov on 04/10/2022.
//

import UIKit

// MARK: - DataSourceInput protocol

private protocol DataSourceInput {
    func media(for indexPath: IndexPath) -> Media?
}

// MARK: - DataSourceOutput protocol

private protocol DataSourceOutput {
    var collectionView: UICollectionView { get }
    var media: [Media] { get }
    var viewModel: DetailViewModel { get }
    var numberOfSections: Int { get }
}

// MARK: - DataSource typealias

private typealias DataSource = DataSourceInput & DataSourceOutput

// MARK: - DetailCollectionViewDataSource class

final class DetailCollectionViewDataSource: NSObject,
                                            DataSource,
                                            UICollectionViewDelegate,
                                            UICollectionViewDataSource,
                                            UICollectionViewDataSourcePrefetching {
    
    fileprivate var collectionView: UICollectionView
    fileprivate var media: [Media]
    fileprivate var viewModel: DetailViewModel
    fileprivate let numberOfSections = 1
    
    private var cache: NSCache<NSString, UIImage> { AsyncImageFetcher.shared.cache }
    
    init(collectionView: UICollectionView,
         media: [Media],
         with viewModel: DetailViewModel) {
        self.collectionView = collectionView
        self.media = media
        self.viewModel = viewModel
    }
    
    fileprivate func media(for indexPath: IndexPath) -> Media? {
        return viewModel.state == .tvShows
            ? viewModel.section.tvshows![indexPath.row] as Media?
            : viewModel.section.movies![indexPath.row] as Media?
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { numberOfSections }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int { media.count }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return CollectionViewCell.create(in: collectionView,
                                         reuseIdentifier: StandardCollectionViewCell.reuseIdentifier,
                                         section: viewModel.section,
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
            CollectionViewCell.download(with: cellViewModel)
        }
    }
}

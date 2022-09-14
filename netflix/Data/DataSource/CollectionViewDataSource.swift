//
//  CollectionViewDataSource.swift
//  netflix
//
//  Created by Zach Bazov on 13/09/2022.
//

import UIKit

// MARK: - CollectionViewDataSource

final class CollectionViewDataSource<Cell>: NSObject,
                                            UICollectionViewDelegate,
                                            UICollectionViewDataSource,
                                            UICollectionViewDataSourcePrefetching where Cell: UICollectionViewCell {
    
    var section: Section
    var viewModel: DefaultHomeViewModel
    
    var standardCell: TableViewCell<Cell>!
    
    var cache: NSCache<NSString, UIImage> { AsyncImageFetcher.shared.cache }
    
    init(_ section: Section, viewModel: DefaultHomeViewModel) {
        self.section = section
        self.viewModel = viewModel
    }
    
    convenience init(_ section: Section,
                     viewModel: DefaultHomeViewModel,
                     standardCell: TableViewCell<Cell>) {
        self.init(section, viewModel: viewModel)
        self.standardCell = standardCell
    }
    
    deinit {
        standardCell = nil
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        guard let indices = TableViewDataSource.Indices(rawValue: self.section.id) else { return .zero }
        switch indices {
        case .display,
                .ratable,
                .resumable:
            return viewModel.state.value == .tvShows
                ? viewModel.sections.value.first!.tvshows!.count
                : viewModel.sections.value.first!.movies!.count
        default:
            guard let standardCell = standardCell else { return .zero }
            return viewModel.state.value == .tvShows
                ? standardCell.section.tvshows!.count
                : standardCell.section.movies!.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return CollectionViewCell.create(in: collectionView,
                                         reuseIdentifier: Cell.reuseIdentifier,
                                         section: section,
                                         for: indexPath,
                                         with: viewModel)
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {}
    
    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {}
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {}
    
    // MARK: UICollectionViewDataSourcePrefetching
    
    func collectionView(_ collectionView: UICollectionView,
                        prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            guard let media = media(for: indexPath) else { fatalError() }
            let cellViewModel = CollectionViewCellItemViewModel(media: media,
                                                                indexPath: indexPath)
            CollectionViewCell.download(with: cellViewModel)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {}
    
    private func media(for indexPath: IndexPath) -> Media? {
        if let standardCell = standardCell {
            return viewModel.state.value == .tvShows
                ? standardCell.section.tvshows![indexPath.row] as Media?
                : standardCell.section.movies![indexPath.row] as Media?
        }
        
        return viewModel.state.value == .tvShows
            ? viewModel.sections.value.first!.tvshows![indexPath.row] as Media?
            : viewModel.sections.value.first!.movies![indexPath.row] as Media?
    }
}

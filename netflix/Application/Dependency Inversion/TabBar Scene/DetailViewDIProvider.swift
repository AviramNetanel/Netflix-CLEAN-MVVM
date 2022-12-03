//
//  DetailViewDIProvider.swift
//  netflix
//
//  Created by Zach Bazov on 30/11/2022.
//

import UIKit.UITableView

// MARK: - DetailViewDIProvider class

final class DetailViewDIProvider {
    
    struct Dependencies {
        weak var detailViewController: DetailViewController!
        weak var detailViewModel: DetailViewModel!
        weak var tableView: UITableView!
    }
    
    let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

// MARK: - PreviewViewDependencies implementation

extension DetailViewDIProvider: PreviewViewDependencies {
    
    func createPreviewView() -> PreviewView {
        return PreviewView(on: dependencies.detailViewController.previewContainer,
                           with: dependencies.detailViewModel)
    }
}

// MARK: - DetailTableViewDataSourceDependencies implementation

extension DetailViewDIProvider: DetailTableViewDataSourceDependencies {
    
    func createDetailTableViewDataSourceActions() -> DetailTableViewDataSourceActions {
        return DetailTableViewDataSourceActions(heightForRowAt: dependencies.detailViewController.heightForRow())
    }
    
    func createDetailTableViewDataSource() -> DetailTableViewDataSource {
        return DetailTableViewDataSource(using: self, actions: createDetailTableViewDataSourceActions())
    }
    
    func createDetailInfoTableViewCell() -> DetailInfoTableViewCell {
        return DetailInfoTableViewCell(using: self)
    }
    
    func createDetailInfoViewViewModel() -> DetailInfoViewViewModel {
        return DetailInfoViewViewModel(with: dependencies.detailViewModel)
    }
    
    func createDetailInfoView(on view: UIView) -> DetailInfoView {
        return DetailInfoView(on: view, with: createDetailInfoViewViewModel())
    }
    
    func createDetailDescriptionTableViewCell() -> DetailDescriptionTableViewCell {
        return DetailDescriptionTableViewCell(using: self)
    }
    
    func createDetailDescriptionViewViewModel() -> DetailDescriptionViewViewModel {
        return DetailDescriptionViewViewModel(with: dependencies.detailViewModel.dependencies.media)
    }
    
    func createDetailDescriptionView(on view: UIView) -> DetailDescriptionView {
        return DetailDescriptionView(on: view, with: createDetailDescriptionViewViewModel())
    }
    
    func createDetailPanelTableViewCell() -> DetailPanelTableViewCell {
        return DetailPanelTableViewCell(using: self)
    }
    
    func createDetailPanelView(on view: UIView) -> DetailPanelView {
        return DetailPanelView(using: self, on: view)
    }
    
    func createDetailPanelViewItemConfiguration(
        on item: DetailPanelViewItem) -> DetailPanelViewItemConfiguration {
            return DetailPanelViewItemConfiguration(view: item, with: dependencies.detailViewModel)
        }
    
    func createDetailPanelViewItemViewModel(
        on item: DetailPanelViewItem) -> DetailPanelViewItemViewModel {
            return DetailPanelViewItemViewModel(item: item, with: dependencies.detailViewModel)
        }
    
    func createDetailPanelViewItem(on view: UIView) -> DetailPanelViewItem {
        return DetailPanelViewItem(using: self, on: view)
    }
    
    func createDetailNavigationTableViewCell() -> DetailNavigationTableViewCell {
        return DetailNavigationTableViewCell(using: self)
    }
    
    func createDetailNavigationView(on view: UIView) -> DetailNavigationView {
        return DetailNavigationView(using: self, on: view)
    }
    
    func createDetailNavigationViewItem(using navigationView: DetailNavigationView,
                                        on view: UIView) -> DetailNavigationViewItem {
        return DetailNavigationViewItem(using: self, navigationView: navigationView, on: view)
    }
    
    func createDetailNavigationViewItemConfiguration(
        using navigationView: DetailNavigationView,
        on item: DetailNavigationViewItem) -> DetailNavigationViewItemConfiguration {
            return DetailNavigationViewItemConfiguration(on: item, with: navigationView)
        }
    
    func createDetailNavigationViewItemViewModel(
        on item: DetailNavigationViewItem) -> DetailNavigationViewItemViewModel {
            return DetailNavigationViewItemViewModel(with: item)
        }
    
    func createDetailCollectionTableViewCell() -> DetailCollectionTableViewCell {
        return DetailCollectionTableViewCell(using: self)
    }
    
    func createDetailCollectionView(on view: UIView) -> DetailCollectionView {
        return DetailCollectionView(using: self, on: view)
    }
}

// MARK: - DetailCollectionViewDataSourceDependencies implementation

extension DetailViewDIProvider: DetailCollectionViewDataSourceDependencies {
    
    func createDetailCollectionViewDataSource(
        on collectionView: UICollectionView,
        with items: [Mediable]) -> DetailCollectionViewDataSource<Mediable> {
            return DetailCollectionViewDataSource(using: self,
                                                  collectionView: collectionView,
                                                  items: items)
        }
    
    func createEpisodeCollectionViewCell(
        on collectionView: UICollectionView,
        for indexPath: IndexPath) -> EpisodeCollectionViewCell {
            return .create(using: self, on: collectionView, for: indexPath)
        }
    
    func createEpisodeCollectionViewCellViewModel() -> EpisodeCollectionViewCellViewModel {
        return EpisodeCollectionViewCellViewModel(with: dependencies.detailViewModel)
    }
    
    func createTrailerCollectionViewCell(
        on collectionView: UICollectionView,
        for indexPath: IndexPath) -> TrailerCollectionViewCell {
            return .create(using: self, on: collectionView, for: indexPath)
        }
    
    func createTrailerCollectionViewCellViewModel() -> TrailerCollectionViewCellViewModel {
        return TrailerCollectionViewCellViewModel(with: dependencies.detailViewModel.dependencies.media)
    }
    
    func createCollectionViewCell(
        on collectionView: UICollectionView,
        reuseIdentifier: String,
        section: Section,
        for indexPath: IndexPath) -> CollectionViewCell {
            return .create(on: collectionView,
                           reuseIdentifier: reuseIdentifier,
                           section: section,
                           for: indexPath)
        }
}

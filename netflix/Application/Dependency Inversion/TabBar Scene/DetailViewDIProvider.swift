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
    
    func createDetailTableViewDataSource() -> DetailTableViewDataSource {
        return DetailTableViewDataSource(using: self)
    }
    
    func createDetailInfoTableViewCell() -> DetailInfoTableViewCell {
        return DetailInfoTableViewCell(using: self)
    }
    
    func createDetailDescriptionTableViewCell() -> DetailDescriptionTableViewCell {
        return DetailDescriptionTableViewCell(using: self)
    }
    
    func createDetailPanelTableViewCell() -> DetailPanelTableViewCell {
        return DetailPanelTableViewCell(using: self)
    }
    
    func createDetailNavigationTableViewCell() -> DetailNavigationTableViewCell {
        return DetailNavigationTableViewCell(using: self)
    }
    
    func createDetailCollectionTableViewCell() -> DetailCollectionTableViewCell {
        return DetailCollectionTableViewCell(using: self)
    }
}

extension DetailViewDIProvider {
    
    func createDetailNavigationViewViewModelActions(on view: DetailNavigationView) -> DetailNavigationViewViewModelActions {
        return DetailNavigationViewViewModelActions(stateDidChange: view._stateDidChange(state:))
    }
}

//// MARK: - DetailNavigationViewDependencies implementation
//
//extension DetailViewDIProvider: DetailNavigationViewDependencies {
//
//    func createDetailNavigationViewViewModel() -> DetailNavigationViewViewModel {
//        return DetailNavigationViewViewModel(using: self, dependencies: createDetailNavigationViewViewModelDependencies())
//    }
//
//    func createDetailNavigationViewViewModelDependencies() -> DetailNavigationViewViewModel.Dependencies {
//        return DetailNavigationViewViewModel.Dependencies(actions: createDetailNavigationViewViewModelActions())
//    }
//
//    func createDetailNavigationViewViewModelActions() -> DetailNavigationViewViewModelActions {
//        return DetailNavigationViewViewModelActions(stateDidChange: dependencies.detailViewController.stateDidChange)
//    }
//}

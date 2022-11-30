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
    
    func createDetailInfoTableViewCell(for indexPath: IndexPath) -> DetailInfoTableViewCell {
        return DetailInfoTableViewCell(using: self, for: indexPath)
    }
    
    func createDetailDescriptionTableViewCell(for indexPath: IndexPath) -> DetailDescriptionTableViewCell {
        return DetailDescriptionTableViewCell(using: self, for: indexPath)
    }
    
    func createDetailPanelTableViewCell(for indexPath: IndexPath) -> DetailPanelTableViewCell {
        return DetailPanelTableViewCell(using: self, for: indexPath)
    }
    
    func createDetailNavigationTableViewCell(for indexPath: IndexPath) -> DetailNavigationTableViewCell {
        return DetailNavigationTableViewCell(using: self, for: indexPath)
    }
    
    func createDetailCollectionTableViewCell(for indexPath: IndexPath) -> DetailCollectionTableViewCell {
        return DetailCollectionTableViewCell(using: self, for: indexPath)
    }
}

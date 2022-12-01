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

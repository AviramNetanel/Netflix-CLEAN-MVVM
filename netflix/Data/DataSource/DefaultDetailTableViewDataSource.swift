//
//  DefaultDetailTableViewDataSource.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit

// MARK: - DetailTableViewDataSourceInput protocol

private protocol DetailTableViewDataSourceInput {
    var heightForRow: ((IndexPath) -> CGFloat)? { get }
}

// MARK: - DetailTableViewDataSourceOutput protocol

private protocol DetailTableViewDataSourceOutput {
    var previewCell: DetailPreviewTableViewCell! { get }
    var infoCell: DetailInfoTableViewCell! { get }
    var descriptionCell: DetailDescriptionTableViewCell! { get }
    var panelCell: DetailPanelTableViewCell! { get }
    var navigationCell: DetailNavigationTableViewCell! { get }
    var collectionCell: DetailCollectionTableViewCell! { get }
}

// MARK: - DetailTableViewDataSource protocol

private protocol DetailTableViewDataSource: DetailTableViewDataSourceInput,
                                            DetailTableViewDataSourceOutput {}

// MARK: - DefaultDetailTableViewDataSource class

final class DefaultDetailTableViewDataSource: NSObject,
                                              DetailTableViewDataSource,
                                              UITableViewDelegate,
                                              UITableViewDataSource {
    
    enum Index: Int, CaseIterable {
        case preview
        case info
        case description
        case panel
        case navigation
        case collection
    }
    
    private var viewModel: DefaultDetailViewModel
    
    var heightForRow: ((IndexPath) -> CGFloat)?
    
    fileprivate var previewCell: DetailPreviewTableViewCell!
    fileprivate var infoCell: DetailInfoTableViewCell!
    fileprivate var descriptionCell: DetailDescriptionTableViewCell!
    fileprivate var panelCell: DetailPanelTableViewCell!
    fileprivate var navigationCell: DetailNavigationTableViewCell!
    fileprivate var collectionCell: DetailCollectionTableViewCell!
    
    init(with viewModel: DefaultDetailViewModel) {
        self.viewModel = viewModel
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { Index.allCases.count }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int { 1 }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let index = Index(rawValue: indexPath.section) else { fatalError() }
        switch index {
        case .preview:
            previewCell = DetailPreviewTableViewCell.create(in: tableView,
                                                            for: indexPath,
                                                            with: viewModel)
            return previewCell
        case .info:
            infoCell = DetailInfoTableViewCell.create(in: tableView, for: indexPath)
            return infoCell
        case .description:
            descriptionCell = DetailDescriptionTableViewCell.create(in: tableView, for: indexPath)
            return descriptionCell
        case .panel:
            panelCell = DetailPanelTableViewCell.create(in: tableView, for: indexPath)
            return panelCell
        case .navigation:
            navigationCell = DetailNavigationTableViewCell.create(in: tableView, for: indexPath)
            return navigationCell
        case .collection:
            collectionCell = DetailCollectionTableViewCell.create(in: tableView, for: indexPath)
            return collectionCell
        }
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat { heightForRow!(indexPath) }
}

//
//  DetailTableViewDataSource.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit

// MARK: - DataSourceInput protocol

private protocol DataSourceInput {
    var heightForRow: ((IndexPath) -> CGFloat)? { get }
}

// MARK: - DataSourceOutput protocol

private protocol DataSourceOutput {
    var previewCell: DetailPreviewTableViewCell! { get }
    var infoCell: DetailInfoTableViewCell! { get }
    var descriptionCell: DetailDescriptionTableViewCell! { get }
    var panelCell: DetailPanelTableViewCell! { get }
    var navigationCell: DetailNavigationTableViewCell! { get }
    var collectionCell: DetailCollectionTableViewCell! { get }
}

// MARK: - DataSource typealias

private typealias DataSource = DataSourceInput & DataSourceOutput

// MARK: - DetailTableViewDataSource class

final class DetailTableViewDataSource: NSObject,
                                       DataSource,
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
    
    private var viewModel: DetailViewModel
    
    private var tableView: UITableView
    
    var heightForRow: ((IndexPath) -> CGFloat)? { didSet { reload() } }
    
    fileprivate var previewCell: DetailPreviewTableViewCell!
    fileprivate var infoCell: DetailInfoTableViewCell!
    fileprivate var descriptionCell: DetailDescriptionTableViewCell!
    fileprivate var panelCell: DetailPanelTableViewCell!
    fileprivate var navigationCell: DetailNavigationTableViewCell!
    fileprivate(set) var collectionCell: DetailCollectionTableViewCell!
    
    init(viewModel: DetailViewModel,
         tableView: UITableView) {
        self.viewModel = viewModel
        self.tableView = tableView
    }
    
    func reload() { tableView.reloadData() }
    
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
            infoCell = DetailInfoTableViewCell.create(in: tableView,
                                                      for: indexPath)
            return infoCell
        case .description:
            descriptionCell = DetailDescriptionTableViewCell.create(in: tableView,
                                                                    for: indexPath)
            return descriptionCell
        case .panel:
            panelCell = DetailPanelTableViewCell.create(in: tableView,
                                                        for: indexPath)
            return panelCell
        case .navigation:
            navigationCell = DetailNavigationTableViewCell.create(in: tableView,
                                                                  for: indexPath)
            return navigationCell
        case .collection:
            collectionCell = DetailCollectionTableViewCell.create(in: tableView,
                                                                  for: indexPath,
                                                                  with: viewModel)
            return collectionCell
        }
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat { heightForRow!(indexPath) }
}

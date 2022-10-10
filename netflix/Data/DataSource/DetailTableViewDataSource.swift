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
        case info
        case description
        case panel
        case navigation
        case collection
    }
    
    private var viewModel: DetailViewModel
    
    private var tableView: UITableView
    
    var heightForRow: ((IndexPath) -> CGFloat)? { didSet { reload() } }
    
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
        case .info:
            guard infoCell == nil else { return infoCell }
            infoCell = DetailInfoTableViewCell.create(in: tableView,
                                                      for: indexPath,
                                                      with: viewModel)
            return infoCell
        case .description:
            guard descriptionCell == nil else { return descriptionCell }
            descriptionCell = DetailDescriptionTableViewCell.create(in: tableView,
                                                                    for: indexPath,
                                                                    with: viewModel)
            return descriptionCell
        case .panel:
            guard panelCell == nil else { return panelCell }
            panelCell = DetailPanelTableViewCell.create(in: tableView,
                                                        for: indexPath)
            return panelCell
        case .navigation:
            guard navigationCell == nil else { return navigationCell }
            navigationCell = DetailNavigationTableViewCell.create(in: tableView,
                                                                  for: indexPath)
            return navigationCell
        case .collection:
            guard collectionCell == nil else { return collectionCell }
            collectionCell = DetailCollectionTableViewCell.create(in: tableView,
                                                                  for: indexPath,
                                                                  with: viewModel)
            return collectionCell
        }
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat { heightForRow!(indexPath) }
}

//
//  DetailTableViewDataSource.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit

// MARK: - DataSourcingInput protocol

private protocol DataSourcingInput {
    func reload()
}

// MARK: - DataSourcingOutput protocol

private protocol DataSourcingOutput {
    var infoCell: DetailInfoTableViewCell! { get }
    var descriptionCell: DetailDescriptionTableViewCell! { get }
    var panelCell: DetailPanelTableViewCell! { get }
    var navigationCell: DetailNavigationTableViewCell! { get }
    var collectionCell: DetailCollectionTableViewCell! { get }
    var heightForRow: ((IndexPath) -> CGFloat)? { get }
}

// MARK: - DataSourcing typealias

private typealias DataSourcing = DataSourcingInput & DataSourcingOutput

// MARK: - DetailTableViewDataSource class

final class DetailTableViewDataSource: NSObject,
                                       DataSourcing,
                                       UITableViewDelegate,
                                       UITableViewDataSource {
    
    enum Index: Int, CaseIterable {
        case info
        case description
        case panel
        case navigation
        case collection
    }
    
    private var tableView: UITableView
    private var viewModel: DetailViewModel
    
    fileprivate var infoCell: DetailInfoTableViewCell!
    fileprivate var descriptionCell: DetailDescriptionTableViewCell!
    fileprivate(set) var panelCell: DetailPanelTableViewCell!
    fileprivate(set) var navigationCell: DetailNavigationTableViewCell!
    fileprivate(set) var collectionCell: DetailCollectionTableViewCell!
    
    var heightForRow: ((IndexPath) -> CGFloat)? { didSet { reload() } }
    
    init(tableView: UITableView,
         viewModel: DetailViewModel) {
        self.tableView = tableView
        self.viewModel = viewModel
    }
    
    deinit {
        infoCell = nil
        descriptionCell = nil
        panelCell = nil
        navigationCell = nil
        collectionCell = nil
        heightForRow = nil
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
            navigationCell.navigationView._stateDidChange = { [weak self] state in
                self?.viewModel.navigationViewState.value = state
            }
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

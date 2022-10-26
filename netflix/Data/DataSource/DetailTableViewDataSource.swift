//
//  DetailTableViewDataSource.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit

// MARK: - DataSourcingInput protocol

private protocol DataSourcingInput {
    var _heightForRow: ((IndexPath) -> CGFloat)? { get }
}

// MARK: - DataSourcingOutput protocol

private protocol DataSourcingOutput {
    var tableView: UITableView! { get }
    var viewModel: DetailViewModel! { get }
    var numberOfRows: Int { get }
    var infoCell: DetailInfoTableViewCell! { get }
    var descriptionCell: DetailDescriptionTableViewCell! { get }
    var panelCell: DetailPanelTableViewCell! { get }
    var navigationCell: DetailNavigationTableViewCell! { get }
    var collectionCell: DetailCollectionTableViewCell! { get }
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
    
    fileprivate let numberOfRows: Int = 1
    
    fileprivate var tableView: UITableView!
    fileprivate var viewModel: DetailViewModel!
    fileprivate var homeViewModel: HomeViewModel!
    
    fileprivate var infoCell: DetailInfoTableViewCell!
    fileprivate var descriptionCell: DetailDescriptionTableViewCell!
    fileprivate(set) var panelCell: DetailPanelTableViewCell!
    fileprivate(set) var navigationCell: DetailNavigationTableViewCell!
    fileprivate(set) var collectionCell: DetailCollectionTableViewCell!
    
    var _heightForRow: ((IndexPath) -> CGFloat)? {
        didSet { tableView.reloadData() }
    }
    
    deinit {
        infoCell = nil
        descriptionCell = nil
        panelCell = nil
        navigationCell = nil
        collectionCell = nil
        _heightForRow = nil
        tableView = nil
        viewModel = nil
        homeViewModel = nil
    }
    
    static func create(on tableView: UITableView,
                       viewModel: DetailViewModel,
                       homeViewModel: HomeViewModel) -> DetailTableViewDataSource {
        let dataSource = DetailTableViewDataSource()
        dataSource.tableView = tableView
        dataSource.viewModel = viewModel
        dataSource.homeViewModel = homeViewModel
        return dataSource
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { Index.allCases.count }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int { numberOfRows }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let index = Index(rawValue: indexPath.section) else { fatalError() }
        switch index {
        case .info:
            guard infoCell == nil else { return infoCell }
            infoCell = DetailInfoTableViewCell.create(on: tableView,
                                                      for: indexPath,
                                                      with: viewModel)
            return infoCell
        case .description:
            guard descriptionCell == nil else { return descriptionCell }
            descriptionCell = DetailDescriptionTableViewCell.create(on: tableView,
                                                                    for: indexPath,
                                                                    with: viewModel)
            return descriptionCell
        case .panel:
            guard panelCell == nil else { return panelCell }
            panelCell = DetailPanelTableViewCell.create(on: tableView,
                                                        for: indexPath,
                                                        viewModel: viewModel,
                                                        homeViewModel: homeViewModel)
            return panelCell
        case .navigation:
            guard navigationCell == nil else { return navigationCell }
            navigationCell = DetailNavigationTableViewCell.create(on: tableView,
                                                                  for: indexPath,
                                                                  with: viewModel)
            navigationCell.navigationView._stateDidChange = { [weak self] state in
                self?.viewModel.navigationViewState.value = state
            }
            return navigationCell
        case .collection:
            guard collectionCell == nil else { return collectionCell }
            collectionCell = DetailCollectionTableViewCell.create(on: tableView,
                                                                  for: indexPath,
                                                                  with: viewModel)
            return collectionCell
        }
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat { _heightForRow!(indexPath) }
}

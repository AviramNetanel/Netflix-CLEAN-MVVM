//
//  DetailTableViewDataSource.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit.UITableView

// MARK: - DetailTableViewDataSourceDependencies protocol

protocol DetailTableViewDataSourceDependencies {
    func createDetailTableViewDataSource() -> DetailTableViewDataSource
    func createDetailInfoTableViewCell(for indexPath: IndexPath) -> DetailInfoTableViewCell
    func createDetailDescriptionTableViewCell(for indexPath: IndexPath) -> DetailDescriptionTableViewCell
    func createDetailPanelTableViewCell(for indexPath: IndexPath) -> DetailPanelTableViewCell
    func createDetailNavigationTableViewCell(for indexPath: IndexPath) -> DetailNavigationTableViewCell
    func createDetailCollectionTableViewCell(for indexPath: IndexPath) -> DetailCollectionTableViewCell
}

// MARK: - DataSourceInput protocol

private protocol DataSourceInput {
    func viewsDidRegister()
    func dataSourceDidChange()
    var _heightForRow: ((IndexPath) -> CGFloat)? { get }
}

// MARK: - DataSourceOutput protocol

private protocol DataSourceOutput {
    var tableView: UITableView { get }
    var numberOfRows: Int { get }
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
    
    private let diProvider: DetailViewDIProvider
    fileprivate let tableView: UITableView
    fileprivate let numberOfRows: Int = 1
    
    fileprivate var infoCell: DetailInfoTableViewCell!
    fileprivate var descriptionCell: DetailDescriptionTableViewCell!
    fileprivate(set) var panelCell: DetailPanelTableViewCell!
    fileprivate(set) var navigationCell: DetailNavigationTableViewCell!
    fileprivate(set) var collectionCell: DetailCollectionTableViewCell!
    
    var _heightForRow: ((IndexPath) -> CGFloat)? {
        didSet { tableView.reloadData() }
    }
    
    init(using diProvider: DetailViewDIProvider) {
        self.diProvider = diProvider
        self.tableView = diProvider.dependencies.tableView
        super.init()
        self.viewsDidRegister()
        self.dataSourceDidChange()
    }
    
    deinit {
        _heightForRow = nil
        infoCell = nil
        descriptionCell = nil
        panelCell = nil
        navigationCell = nil
        collectionCell = nil
    }
    
    fileprivate func viewsDidRegister() {
        tableView.register(class: DetailInfoTableViewCell.self)
        tableView.register(class: DetailDescriptionTableViewCell.self)
        tableView.register(class: DetailPanelTableViewCell.self)
        tableView.register(class: DetailNavigationTableViewCell.self)
        tableView.register(class: DetailCollectionTableViewCell.self)
    }
    
    fileprivate func dataSourceDidChange() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Index.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let index = Index(rawValue: indexPath.section) else { fatalError() }
        switch index {
        case .info:
            guard infoCell == nil else { return infoCell }
            infoCell = diProvider.createDetailInfoTableViewCell(for: indexPath)
            return infoCell
        case .description:
            guard descriptionCell == nil else { return descriptionCell }
            descriptionCell = diProvider.createDetailDescriptionTableViewCell(for: indexPath)
            return descriptionCell
        case .panel:
            guard panelCell == nil else { return panelCell }
            panelCell = diProvider.createDetailPanelTableViewCell(for: indexPath)
            return panelCell
        case .navigation:
            guard navigationCell == nil else { return navigationCell }
            navigationCell = diProvider.createDetailNavigationTableViewCell(for: indexPath)
            navigationCell.navigationView._stateDidChange = { [weak self] state in
                self?.diProvider.dependencies.detailViewModel.navigationViewState.value = state
            }
            return navigationCell
        case .collection:
            guard collectionCell == nil else { return collectionCell }
            collectionCell = diProvider.createDetailCollectionTableViewCell(for: indexPath)
            return collectionCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return _heightForRow!(indexPath)
    }
}

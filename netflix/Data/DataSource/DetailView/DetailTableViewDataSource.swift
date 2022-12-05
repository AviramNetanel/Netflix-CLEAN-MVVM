//
//  DetailTableViewDataSource.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit.UITableView

// MARK: - DetailTableViewDataSourceActions struct

struct DetailTableViewDataSourceActions {
    let heightForRowAt: (IndexPath) -> CGFloat
}

// MARK: - DetailTableViewDataSourceDependencies protocol

protocol DetailTableViewDataSourceDependencies {
    func createDetailTableViewDataSourceActions() -> DetailTableViewDataSourceActions
    func createDetailTableViewDataSource() -> DetailTableViewDataSource
    func createDetailInfoTableViewCell() -> DetailInfoTableViewCell
    func createDetailInfoViewViewModel() -> DetailInfoViewViewModel
    func createDetailInfoView(on view: UIView) -> DetailInfoView
    func createDetailDescriptionTableViewCell() -> DetailDescriptionTableViewCell
    func createDetailDescriptionViewViewModel() -> DetailDescriptionViewViewModel
    func createDetailDescriptionView(on view: UIView) -> DetailDescriptionView
    func createDetailPanelTableViewCell() -> DetailPanelTableViewCell
    func createDetailPanelView(on view: UIView) -> DetailPanelView
    func createDetailPanelViewItemConfiguration(on item: DetailPanelViewItem) -> DetailPanelViewItemConfiguration
    func createDetailPanelViewItemViewModel(on item: DetailPanelViewItem) -> DetailPanelViewItemViewModel
    func createDetailPanelViewItem(on view: UIView) -> DetailPanelViewItem
    func createDetailNavigationTableViewCell() -> DetailNavigationTableViewCell
    func createDetailNavigationView(on view: UIView) -> DetailNavigationView
    func createDetailNavigationViewItem(using navigationView: DetailNavigationView, on view: UIView) -> DetailNavigationViewItem
    func createDetailNavigationViewItemConfiguration(using navigationView: DetailNavigationView,
                                                     on item: DetailNavigationViewItem) -> DetailNavigationViewItemConfiguration
    func createDetailNavigationViewItemViewModel(on item: DetailNavigationViewItem) -> DetailNavigationViewItemViewModel
    func createDetailCollectionTableViewCell() -> DetailCollectionTableViewCell
    func createDetailCollectionView(on view: UIView) -> DetailCollectionView
}

// MARK: - DataSourceInput protocol

private protocol DataSourceInput {
    func viewsDidRegister()
    func dataSourceDidChange()
}

// MARK: - DataSourceOutput protocol

private protocol DataSourceOutput {
    var tableView: UITableView { get }
    var viewModel: DetailViewModel { get }
    var actions: DetailTableViewDataSourceActions { get }
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
    
    fileprivate let viewModel: DetailViewModel
    fileprivate let actions: DetailTableViewDataSourceActions
    fileprivate let tableView: UITableView
    fileprivate let numberOfRows: Int = 1
    
    fileprivate var infoCell: DetailInfoTableViewCell!
    fileprivate var descriptionCell: DetailDescriptionTableViewCell!
    fileprivate(set) var panelCell: DetailPanelTableViewCell!
    fileprivate(set) var navigationCell: DetailNavigationTableViewCell!
    fileprivate(set) var collectionCell: DetailCollectionTableViewCell!
    
    init(on tableView: UITableView, actions: DetailTableViewDataSourceActions, with viewModel: DetailViewModel) {
        self.tableView = tableView
        self.actions = actions
        self.viewModel = viewModel
        super.init()
        self.viewsDidRegister()
        self.dataSourceDidChange()
    }
    
    deinit {
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
        if case .info = index {
            guard infoCell == nil else { return infoCell }
            infoCell = DetailInfoTableViewCell(with: viewModel)
            return infoCell
        } else if case .description = index {
            guard descriptionCell == nil else { return descriptionCell }
            descriptionCell = DetailDescriptionTableViewCell(with: viewModel)
            return descriptionCell
        } else if case .panel = index {
            guard panelCell == nil else { return panelCell }
            panelCell = DetailPanelTableViewCell(with: viewModel)
            return panelCell
        } else if case .navigation = index {
            guard navigationCell == nil else { return navigationCell }
            navigationCell = DetailNavigationTableViewCell(with: viewModel)
            return navigationCell
        } else {
            guard collectionCell == nil else { return collectionCell }
            collectionCell = DetailCollectionTableViewCell(with: viewModel)
            return collectionCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return actions.heightForRowAt(indexPath)
    }
}

extension DetailTableViewDataSource {
    
    func contentSize(with state: DetailNavigationView.State) -> Float {
        switch state {
        case .episodes:
            guard let season = viewModel.season.value as Season? else { return .zero }
            let cellHeight = Float(156.0)
            let lineSpacing = Float(8.0)
            let itemsCount = Float(season.episodes.count)
            let value = cellHeight * itemsCount + (lineSpacing * itemsCount)
            return Float(value)
        case .trailers:
            guard let trailers = viewModel.media.resources.trailers as [String]? else { return .zero }
            let cellHeight = Float(224.0)
            let lineSpacing = Float(8.0)
            let itemsCount = Float(trailers.count)
            let value = cellHeight * itemsCount + (lineSpacing * itemsCount)
            return Float(value)
        default:
            let cellHeight = Float(146.0)
            let lineSpacing = Float(8.0)
            let itemsPerLine = Float(3.0)
            let topContentInset = Float(16.0)
            let itemsCount = viewModel.homeDataSourceState == .series
                ? Float(viewModel.section.media.count)
                : Float(viewModel.section.media.count)
            let roundedItemsOutput = (itemsCount / itemsPerLine).rounded(.awayFromZero)
            let value =
                roundedItemsOutput * cellHeight
                + lineSpacing * roundedItemsOutput
                + topContentInset
            return Float(value)
        }
    }
}

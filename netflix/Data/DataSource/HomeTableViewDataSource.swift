//
//  HomeTableViewDataSource.swift
//  netflix
//
//  Created by Zach Bazov on 13/09/2022.
//

import UIKit

// MARK: - HomeTableViewDataSourceDependencies protocol

protocol HomeTableViewDataSourceDependencies {
    func createHomeTableViewDataSource() -> HomeTableViewDataSource
    func createHomeTableViewDataSourceActions() -> HomeTableViewDataSourceActions
    func createHomeDisplayTableViewCell(for indexPath: IndexPath) -> DisplayTableViewCell
    func createHomeRatedTableViewCell(for indexPath: IndexPath,
                                      with actions: CollectionViewDataSourceActions) -> RatedTableViewCell
    func createHomeResumableTableViewCell(for indexPath: IndexPath,
                                          with actions: CollectionViewDataSourceActions) -> ResumableTableViewCell
    func createHomeStandardTableViewCell(for indexPath: IndexPath,
                                         with actions: CollectionViewDataSourceActions) -> StandardTableViewCell
    func createHomeTableViewHeaderFooterView(at section: Int) -> TableViewHeaderFooterView
}

// MARK: - HomeTableViewDataSourceActions struct

struct HomeTableViewDataSourceActions {
    
    let heightForRowAt: (IndexPath) -> CGFloat
    let viewDidScroll: (UIScrollView) -> Void
    let didSelectItem: (Int, Int) -> Void
    
    init(using diProvider: HomeViewDIProvider) {
        self.heightForRowAt = diProvider.dependencies.homeViewController.heightForRow(at:)
        self.viewDidScroll = diProvider.dependencies.homeViewController.viewDidScroll(in:)
        self.didSelectItem = diProvider.dependencies.homeViewController.didSelectItem(at:of:)
    }
}

// MARK: - DataSourceInput protocol

private protocol DataSourceInput {
    func viewDidLoad()
    func viewsDidRegister()
    func dataSourceDidChange()
}

// MARK: - DataSourceOutput protocol

private protocol DataSourceOutput {
    var numberOfRows: Int { get }
    var displayCell: DisplayTableViewCell! { get }
}

// MARK: - DataSource protocol

private typealias DataSource = DataSourceInput & DataSourceOutput

// MARK: - HomeTableViewDataSource class

final class HomeTableViewDataSource: NSObject, DataSource {
    
    enum Index: Int, CaseIterable {
        case display
        case ratable
        case resumable
        case action
        case sciFi
        case blockbuster
        case myList
        case crime
        case thriller
        case adventure
        case comedy
        case drama
        case horror
        case anime
        case familyNchildren
        case documentary
    }
    
    enum State: Int {
        case all
        case series
        case films
    }
    
    private let diProvider: HomeViewDIProvider
    private let actions: HomeTableViewDataSourceActions
    
    fileprivate let numberOfRows = 1
    fileprivate(set) var displayCell: DisplayTableViewCell!
    
    init(using diProvider: HomeViewDIProvider, actions: HomeTableViewDataSourceActions) {
        self.diProvider = diProvider
        self.actions = actions
        super.init()
        self.viewDidLoad()
    }
    
    deinit {
        displayCell = nil
    }
    
    fileprivate func viewDidLoad() {
        viewsDidRegister()
        dataSourceDidChange()
    }
    
    fileprivate func viewsDidRegister() {
        guard let tableView = diProvider.dependencies.tableView else { return }
        tableView.register(headerFooter: TableViewHeaderFooterView.self)
        tableView.register(nib: DisplayTableViewCell.self)
        tableView.register(class: RatedTableViewCell.self)
        tableView.register(class: ResumableTableViewCell.self)
        tableView.register(class: StandardTableViewCell.self)
    }
    
    fileprivate func dataSourceDidChange() {
        guard let tableView = diProvider.dependencies.tableView else { return }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource Implementation

extension HomeTableViewDataSource: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return diProvider.dependencies.homeViewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let index = Index(rawValue: indexPath.section) else { fatalError() }
        
        let actions = diProvider.createHomeCollectionViewDataSourceActions(for: index.rawValue, using: actions)
        
        if case .display = index {
            displayCell = diProvider.createHomeDisplayTableViewCell(for: indexPath)
            return displayCell
        } else if case .ratable = index {
            return diProvider.createHomeRatedTableViewCell(for: indexPath, with: actions)
        } else if case .resumable = index {
            return diProvider.createHomeResumableTableViewCell(for: indexPath, with: actions)
        } else {
            return diProvider.createHomeStandardTableViewCell(for: indexPath, with: actions)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return actions.heightForRowAt(indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return diProvider.createHomeTableViewHeaderFooterView(at: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let index = Index(rawValue: section) else { return .zero }
        if case .display = index {
            return 0.0
        } else if case .ratable = index {
            return 28.0
        } else {
            return 24.0
        }
    }
}

// MARK: - UIScrollViewDelegate implementation

extension HomeTableViewDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        actions.viewDidScroll(scrollView)
    }
}

// MARK: - Valuable implementation

extension HomeTableViewDataSource.Index: Valuable {
    
    var stringValue: String {
        switch self {
        case .display, .ratable, .resumable: return ""
        case .action: return "Action"
        case .sciFi: return "Sci-Fi"
        case .blockbuster: return "Blockbusters"
        case .myList: return "My List"
        case .crime: return "Crime"
        case .thriller: return "Thriller"
        case .adventure: return "Adventure"
        case .comedy: return "Comedy"
        case .drama: return "Drama"
        case .horror: return "Horror"
        case .anime: return "Anime"
        case .familyNchildren: return "Family & Children"
        case .documentary: return "Documentary"
        }
    }
}

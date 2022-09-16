//
//  DefaultTableViewDataSource.swift
//  netflix
//
//  Created by Zach Bazov on 13/09/2022.
//

import UIKit

// MARK: - TableViewDataSourceInput protocol

private protocol TableViewDataSourceInput {
    var tableView: UITableView { get }
    var sections: [Section] { get }
}

// MARK: - TableViewDataSourceOutput protocol

private protocol TableViewDataSourceOutput {
    func viewsDidRegister()
    func dataSourceDidChange()
    
    var heightForRowAt: ((IndexPath) -> CGFloat)? { get }
}

// MARK: - TableViewDataSource protocol

private protocol TableViewDataSource: TableViewDataSourceInput, TableViewDataSourceOutput {}

// MARK: - DefaultTableViewDataSource

final class DefaultTableViewDataSource: NSObject, TableViewDataSource {
    
    enum Indices: Int, CaseIterable {
        case display,
             ratable,
             resumable,
             action,
             sciFi,
             blockbuster,
             myList,
             crime,
             thriller,
             adventure,
             comedy,
             drama,
             horror,
             anime,
             familyNchildren,
             documentary
    }
    
    enum State: Int {
        case tvShows
        case movies
    }
    
    fileprivate var tableView: UITableView
    fileprivate var sections: [Section]
    
    private var viewModel: DefaultHomeViewModel!
    var heightForRowAt: ((IndexPath) -> CGFloat)?
    
    var displayCell: DisplayTableViewCell?
    
    init(in tableView: UITableView, with viewModel: DefaultHomeViewModel) {
        self.viewModel = viewModel
        self.tableView = tableView
        self.sections = viewModel.sections.value
        super.init()
        self.setupSubviews()
    }
    
    deinit {
        heightForRowAt = nil
        viewModel = nil
    }
    
    private func setupSubviews() {
        setupTableView()
    }
    
    private func setupTableView() {
        viewsDidRegister()
        dataSourceDidChange()
    }
    
    fileprivate func viewsDidRegister() {
        tableView.register(headerFooter: TableViewHeaderFooterView.self)
        tableView.register(class: DisplayTableViewCell.self)
        tableView.register(class: RatableTableViewCell.self)
        tableView.register(class: ResumableTableViewCell.self)
        
        for identifier in StandardTableViewCell.Identifier.allCases {
            tableView.register(StandardTableViewCell.self,
                               forCellReuseIdentifier: identifier.stringValue)
        }
    }
    
    fileprivate func dataSourceDidChange() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource Implementation

extension DefaultTableViewDataSource: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let indices = Indices(rawValue: indexPath.section) else { fatalError() }
        switch indices {
        case .display:
            displayCell = DisplayTableViewCell.create(in: tableView,
                                               for: indexPath,
                                               with: viewModel)
            return displayCell ?? .init()
        case .ratable:
            return RatableTableViewCell.create(in: tableView,
                                               for: indexPath,
                                               with: viewModel)
        case .resumable:
            return ResumableTableViewCell.create(in: tableView,
                                                 for: indexPath,
                                                 with: viewModel)
        default:
            return StandardTableViewCell.create(in: tableView,
                                                for: indexPath,
                                                with: viewModel)
        }
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        heightForRowAt!(indexPath)
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        return TableViewHeaderFooterView.create(in: tableView,
                                                for: section,
                                                with: viewModel)
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        guard let indices = Indices(rawValue: section) else { return .zero }
        switch indices {
        case .display: return 0.0
        case .ratable: return 28.0
        default: return 24.0
        }
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {}
    
    func tableView(_ tableView: UITableView,
                   didEndDisplaying cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {}
}

// MARK: - Valuable implementation

extension DefaultTableViewDataSource.Indices: Valuable {
    
    var stringValue: String {
        switch self {
        case .display,
                .ratable,
                .resumable:
            return ""
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

//
//  TableViewDataSource.swift
//  netflix
//
//  Created by Zach Bazov on 13/09/2022.
//

import UIKit

// MARK: - DataSourcingInput protocol

private protocol DataSourcingInput {
    func viewDidLoad()
    func viewsDidRegister()
    func dataSourceDidChange()
    var heightForRowAt: ((IndexPath) -> CGFloat)? { get }
    var tableViewDidScroll: ((UIScrollView) -> Void)? { get }
    var didSelectItem: ((Int, Int) -> Void)? { get }
}

// MARK: - DataSourcingOutput protocol

private protocol DataSourcingOutput {
    var tableView: UITableView! { get }
    var sections: [Section]! { get }
    var numberOfRows: Int { get }
    var displayCell: DisplayTableViewCell! { get }
    var viewModel: HomeViewModel! { get }
}

// MARK: - DataSourcing protocol

private typealias DataSourcing = DataSourcingInput & DataSourcingOutput

// MARK: - TableViewDataSource

final class TableViewDataSource: NSObject, DataSourcing {
    
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
        case tvShows
        case movies
    }
    
    fileprivate let numberOfRows: Int = 1
    
    fileprivate var tableView: UITableView!
    fileprivate var sections: [Section]!
    fileprivate var viewModel: HomeViewModel!
    fileprivate(set) var displayCell: DisplayTableViewCell!
    
    var heightForRowAt: ((IndexPath) -> CGFloat)?
    var tableViewDidScroll: ((UIScrollView) -> Void)?
    var didSelectItem: ((Int, Int) -> Void)?
    
    deinit {
        displayCell = nil
        heightForRowAt = nil
        tableViewDidScroll = nil
        didSelectItem = nil
        viewModel = nil
        tableView = nil
        sections = nil
    }
    
    static func create(on tableView: UITableView,
                       with viewModel: HomeViewModel) -> TableViewDataSource {
        let dataSource = TableViewDataSource()
        dataSource.tableView = tableView
        dataSource.sections = viewModel.sections.value
        createViewModel(on: dataSource, with: viewModel)
        dataSource.viewsDidRegister()
        dataSource.viewDidLoad()
        return dataSource
    }
    
    @discardableResult
    private static func createViewModel(on dataSource: TableViewDataSource,
                                        with viewModel: HomeViewModel) -> HomeViewModel {
        dataSource.viewModel = viewModel
        return dataSource.viewModel
    }
    
    fileprivate func viewDidLoad() { dataSourceDidChange() }
    
    fileprivate func viewsDidRegister() {
        tableView.register(headerFooter: TableViewHeaderFooterView.self)
        tableView.register(nib: DisplayTableViewCell.self)
        tableView.register(class: RatableTableViewCell.self)
        tableView.register(class: ResumableTableViewCell.self)
        
        StandardTableViewCell.Identifier.allCases.forEach {
            tableView.register(StandardTableViewCell.self, forCellReuseIdentifier: $0.stringValue)
        }
    }
    
    fileprivate func dataSourceDidChange() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource Implementation

extension TableViewDataSource: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int { sections.count }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int { numberOfRows }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let index = Index(rawValue: indexPath.section) else { fatalError() }
        switch index {
        case .display:
            guard displayCell == nil else { return displayCell }
            displayCell = .create(on: tableView,
                                  for: indexPath,
                                  with: viewModel)
            return displayCell
        case .ratable:
            let cell = RatableTableViewCell.create(on: tableView,
                                                   for: indexPath,
                                                   with: viewModel)!
            cell.dataSource?.didSelectItem = { [weak self] row in
                self?.didSelectItem?(indexPath.section, row)
            }
            return cell
        case .resumable:
            let cell = ResumableTableViewCell.create(on: tableView,
                                                     for: indexPath,
                                                     with: viewModel)!
            cell.dataSource?.didSelectItem = { [weak self] row in
                self?.didSelectItem?(indexPath.section, row)
            }
            return cell
        default:
            let cell = StandardTableViewCell.create(on: tableView,
                                                    for: indexPath,
                                                    with: viewModel)
            cell.dataSource?.didSelectItem = { [weak self] row in
                self?.didSelectItem?(indexPath.section, row)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        heightForRowAt!(indexPath)
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        return TableViewHeaderFooterView.create(on: tableView,
                                                for: section,
                                                with: viewModel)
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        guard let index = Index(rawValue: section) else { return .zero }
        switch index {
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

// MARK: - UIScrollViewDelegate implementation

extension TableViewDataSource {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tableViewDidScroll?(scrollView)
    }
}

// MARK: - Valuable implementation

extension TableViewDataSource.Index: Valuable {
    
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

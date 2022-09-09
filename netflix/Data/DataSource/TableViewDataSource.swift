//
//  TableViewDataSource.swift
//  netflix
//
//  Created by Zach Bazov on 08/09/2022.
//

import UIKit

// MARK: - TableViewSection enum

enum TableViewSection: Int, CaseIterable {
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

// MARK: - Valuable implementation

extension TableViewSection: Valuable {
    var stringValue: String {
        switch self {
        case .display,
                .ratable,
                .resumable,
                .myList:
            return ""
        case .action: return "Action"
        case .sciFi: return "Sci-Fi"
        case .blockbuster: return "Blockbusters"
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

// MARK: - TableViewDataSourceState enum

enum TableViewDataSourceState {
    case tvShows
    case movies
}

// MARK: - TableViewDataSourceInput protocol

protocol TableViewDataSourceInput {
    func didChangeSnapshot()
    func reload()
}

// MARK: - TableViewDataSourceOutput protocol

protocol TableViewDataSourceOutput {
    var tableView: UITableView { get }
    var state: TableViewDataSourceState { get }
    var viewModel: HomeViewModel { get }
}

// MARK: - TableViewDataSource protocol

protocol TableViewDataSource: TableViewDataSourceInput, TableViewDataSourceOutput {}

// MARK: - DefaultTableViewDataSource class

final class DefaultTableViewDataSource: NSObject {
    
    var tableView: UITableView
    var state: TableViewDataSourceState
    var viewModel: HomeViewModel
    
    var heightForRowAt: ((IndexPath) -> CGFloat)?
    
    init(tableView: UITableView,
         state: TableViewDataSourceState,
         viewModel: HomeViewModel) {
        self.tableView = tableView
        self.state = state
        self.viewModel = viewModel
        super.init()
    }
}

// MARK: - TableViewDataSource implementation

extension DefaultTableViewDataSource: TableViewDataSource {
    
    func didChangeSnapshot() {
        
    }
    
    func reload() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource and UITableViewDataSourcePrefetching implementation

extension DefaultTableViewDataSource: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        heightForRowAt?(indexPath) ?? .zero
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return TableViewHeaderFooterView.create(tableView: tableView,
                                                viewModel: viewModel,
                                                at: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let indices = TableViewSection(rawValue: section) else { return .zero }
        switch indices {
        case .display: return .zero
        case .ratable: return 28.0
        default: return 24.0
        }
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.value.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let indices = TableViewSection(rawValue: indexPath.section) else {
            fatalError("Unexpected indexPath for section at: \(indexPath.section)")
        }
        switch indices {
        case .display:
            tableView.register(UINib(nibName: String(describing: DisplayTableViewCell.self), bundle: nil),
                               forCellReuseIdentifier: DisplayTableViewCell.reuseIdentifier)
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DisplayTableViewCell.self), for: indexPath) as? DisplayTableViewCell else { fatalError("Unable to dequeue \(DisplayTableViewCell.self)") }
            
            return cell
        case .ratable:
            return RatableTableViewCell.create(tableView: tableView,
                                               viewModel: viewModel,
                                               at: indexPath)
        case .resumable:
            return ResumableTableViewCell.create(tableView: tableView,
                                                 viewModel: viewModel,
                                                 at: indexPath)
        default:
            return StandardTableViewCell.create(tableView: tableView,
                                                viewModel: viewModel,
                                                at: indexPath)
        }
    }
    
    // MARK: UITableViewDataSourcePrefetching
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        
    }
}

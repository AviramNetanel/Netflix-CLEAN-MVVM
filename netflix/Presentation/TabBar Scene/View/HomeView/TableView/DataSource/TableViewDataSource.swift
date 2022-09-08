//
//  TableViewDataSource.swift
//  netflix
//
//  Created by Zach Bazov on 08/09/2022.
//

import UIKit

// MARK: - TableViewDataSourceState enum

enum TableViewDataSourceState {
    case tvShows
    case movies
}

// MARK: - TableViewDataSourceInput protocol

protocol TableViewDataSourceInput {
    func didChangeSnapshot()
    func didRegisterCells()
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
        self.didRegisterCells()
    }
}

// MARK: - TableViewDataSource implementation

extension DefaultTableViewDataSource: TableViewDataSource {
    
    func didChangeSnapshot() {
        
    }
    
    func didRegisterCells() {
        tableView.register(RatableTableViewCell.self,
                           forCellReuseIdentifier: RatableTableViewCell.reuseIdentifier)
        tableView.register(ResumableTableViewCell.self,
                           forCellReuseIdentifier: ResumableTableViewCell.reuseIdentifier)
        tableView.register(StandardTableViewCell.self,
                           forCellReuseIdentifier: StandardTableViewCell.reuseIdentifier)
        tableView.register(TableViewHeaderFooterView.self,
                           forHeaderFooterViewReuseIdentifier: TableViewHeaderFooterView.reuseIdentifier)
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
        guard let indices = SectionIndices(rawValue: section) else { return .zero }
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
        guard let indices = SectionIndices(rawValue: indexPath.section) else { fatalError("") }
        switch indices {
        case .ratable:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: RatableTableViewCell.reuseIdentifier,
                for: indexPath) as? RatableTableViewCell
            else {
                fatalError("Cannot dequeue reusable cell \(RatableTableViewCell.self) with reuseIdentifier: \(RatableTableViewCell.reuseIdentifier)")
            }
            cell.section = viewModel.sections.value.first!
            cell.configure(with: TableViewCellItemViewModel(section: cell.section))
            return cell
        case .resumable:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ResumableTableViewCell.reuseIdentifier,
                for: indexPath) as? ResumableTableViewCell
            else {
                fatalError("Cannot dequeue reusable cell \(ResumableTableViewCell.self) with reuseIdentifier: \(ResumableTableViewCell.reuseIdentifier)")
            }
            cell.section = viewModel.sections.value.first!
            cell.configure(with: TableViewCellItemViewModel(section: cell.section))
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: StandardTableViewCell.reuseIdentifier,
                for: indexPath) as? StandardTableViewCell
            else {
                fatalError("Cannot dequeue reusable cell \(StandardTableViewCell.self) with reuseIdentifier: \(StandardTableViewCell.reuseIdentifier)")
            }
            cell.section = viewModel.sections.value.first!
            cell.configure(with: TableViewCellItemViewModel(section: cell.section))
            return cell
        }
    }
    
    // MARK: UITableViewDataSourcePrefetching
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        
    }
}

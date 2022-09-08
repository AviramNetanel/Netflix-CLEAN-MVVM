//
//  TableViewDataSource.swift
//  netflix
//
//  Created by Zach Bazov on 08/09/2022.
//

import UIKit

enum TableViewDataSourceState {
    case tvShows
    case movies
}

protocol TableViewDataSourceInput {
    func didChangeSnapshot()
    func didRegisterCells()
    func reload()
}

protocol TableViewDataSourceOutput {
    var tableView: UITableView { get }
    var state: TableViewDataSourceState { get }
    var viewModel: HomeViewModel { get }
}

protocol TableViewDataSource: TableViewDataSourceInput, TableViewDataSourceOutput {}

extension TableViewDataSource {
    
    func didChangeSnapshot() {
        
    }
    
    func didRegisterCells() {
        
    }
    
    func reload() {
        tableView.reloadData()
    }
}

final class DefaultTableViewDataSource: NSObject, TableViewDataSource {
    
    var tableView: UITableView
    var state: TableViewDataSourceState
    var viewModel: HomeViewModel
    
    init(tableView: UITableView,
         state: TableViewDataSourceState,
         viewModel: HomeViewModel) {
        self.tableView = tableView
        self.state = state
        self.viewModel = viewModel
    }
}

extension DefaultTableViewDataSource: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 148.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    // MARK: UITableViewDataSource

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StandardItemTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? StandardItemTableViewCell else {
            fatalError("Cannot dequeue reusable cell \(StandardItemTableViewCell.self) with reuseIdentifier: \(StandardItemTableViewCell.reuseIdentifier)")
        }
        cell.fill(with: .init(section: viewModel.sections.value[indexPath.row]))
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections.value.count
    }
    
    // MARK: UITableViewDataSourcePrefetching
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        
    }
}

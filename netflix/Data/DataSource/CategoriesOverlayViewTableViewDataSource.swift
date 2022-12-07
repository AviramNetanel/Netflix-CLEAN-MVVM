//
//  CategoriesOverlayViewTableViewDataSource.swift
//  netflix
//
//  Created by Zach Bazov on 22/09/2022.
//

import UIKit

private protocol DataSourceInput {}

private protocol DataSourceOutput {
    var numberOfSections: Int { get }
    var viewModel: CategoriesOverlayViewViewModel { get }
}

private typealias DataSourcing = DataSourceInput & DataSourceOutput

final class CategoriesOverlayViewTableViewDataSource: NSObject,
                                                      DataSourcing,
                                                      UITableViewDelegate,
                                                      UITableViewDataSource {
    enum State {
        case none
        case mainMenu
        case categories
    }
    
    private weak var tableView: UITableView!
    fileprivate let viewModel: CategoriesOverlayViewViewModel
    fileprivate let numberOfSections: Int = 1
    
    init(on tableView: UITableView, with viewModel: CategoriesOverlayViewViewModel) {
        self.tableView = tableView
        self.viewModel = viewModel
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return CategoriesOverlayViewTableViewCell(on: tableView, for: indexPath, with: viewModel.items.value)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.isPresented.value = false
    }
}

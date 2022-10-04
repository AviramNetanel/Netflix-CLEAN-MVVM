//
//  CategoriesOverlayViewTableViewDataSource.swift
//  netflix
//
//  Created by Zach Bazov on 22/09/2022.
//

import UIKit

// MARK: - DataSourceInput protocol

private protocol DataSourceInput {}

// MARK: - DataSourceOutput protocol

private protocol DataSourceOutput {
    associatedtype T
    var items: [T] { get }
}

// MARK: - DataSource typealias

private typealias DataSource = DataSourceInput & DataSourceOutput

// MARK: - CategoriesOverlayViewTableViewDataSource class

final class CategoriesOverlayViewTableViewDataSource: NSObject,
                                                      UITableViewDelegate,
                                                      UITableViewDataSource {
    
    typealias T = Valuable
    
    var items: [T]
    private var viewModel: CategoriesOverlayViewViewModel
    
    var tabBarController: UITabBarController?
    
    init(items: [T],
         with viewModel: CategoriesOverlayViewViewModel) {
        self.items = items
        self.viewModel = viewModel
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int { items.count }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return CategoriesOverlayViewTableViewCell.create(in: tableView,
                                                         for: indexPath,
                                                         with: viewModel)
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) { viewModel.isPresented.value = false }
}

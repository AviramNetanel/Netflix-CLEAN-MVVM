//
//  DefaultCategoriesOverlayViewTableViewDataSource.swift
//  netflix
//
//  Created by Zach Bazov on 22/09/2022.
//

import UIKit

// MARK: - CategoriesOverlayViewTableViewDataSourceInput protocol

private protocol CategoriesOverlayViewTableViewDataSourceInput {}

// MARK: - CategoriesOverlayViewTableViewDataSourceOutput protocol

private protocol CategoriesOverlayViewTableViewDataSourceOutput {
    associatedtype T
    var items: [T] { get }
}

// MARK: - CategoriesOverlayViewTableViewDataSource protocol

private protocol CategoriesOverlayViewTableViewDataSource: CategoriesOverlayViewTableViewDataSourceInput,
                                                           CategoriesOverlayViewTableViewDataSourceOutput {}

// MARK: - DefaultCategoriesOverlayViewTableViewDataSource class

final class DefaultCategoriesOverlayViewTableViewDataSource: NSObject,
                                                             UITableViewDelegate,
                                                             UITableViewDataSource {
    
    typealias T = Valuable
    
    var items: [T]
    private var viewModel: DefaultCategoriesOverlayViewViewModel
    
    var tabBarController: UITabBarController?
    
    init(items: [T],
         with viewModel: DefaultCategoriesOverlayViewViewModel) {
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
                   didSelectRowAt indexPath: IndexPath) {
        viewModel.isPresented.value = false
    }
}

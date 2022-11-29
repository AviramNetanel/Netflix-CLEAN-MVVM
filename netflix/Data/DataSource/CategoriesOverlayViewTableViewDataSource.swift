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
    var numberOfSections: Int { get }
    var viewModel: CategoriesOverlayViewViewModel { get }
}

// MARK: - DataSourcing typealias

private typealias DataSourcing = DataSourceInput & DataSourceOutput

// MARK: - CategoriesOverlayViewTableViewDataSource class

final class CategoriesOverlayViewTableViewDataSource: NSObject,
                                                      DataSourcing,
                                                      UITableViewDelegate,
                                                      UITableViewDataSource {
    
    enum State {
        case none
        case mainMenu
        case categories
    }
    
    private let diProvider: HomeViewDIProvider
    fileprivate let viewModel: CategoriesOverlayViewViewModel
    fileprivate let numberOfSections: Int = 1
    
    init(using diProvider: HomeViewDIProvider, with viewModel: CategoriesOverlayViewViewModel) {
        self.diProvider = diProvider
        self.viewModel = viewModel
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return diProvider.createCategoriesOverlayViewTableViewCell(for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.isPresented.value = false
    }
}

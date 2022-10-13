//
//  CategoriesOverlayViewTableViewDataSource.swift
//  netflix
//
//  Created by Zach Bazov on 22/09/2022.
//

import UIKit

// MARK: - DataSourcingInput protocol

private protocol DataSourcingInput {}

// MARK: - DataSourcingOutput protocol

private protocol DataSourcingOutput {
    associatedtype T
    var items: [T] { get }
}

// MARK: - DataSourcing typealias

private typealias DataSourcing = DataSourcingInput & DataSourcingOutput

// MARK: - CategoriesOverlayViewTableViewDataSource class

final class CategoriesOverlayViewTableViewDataSource: NSObject,
                                                      DataSourcing,
                                                      UITableViewDelegate,
                                                      UITableViewDataSource {
    
    typealias T = Valuable
    
    var items: [T]
    private var viewModel: CategoriesOverlayViewViewModel
    
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
                   didSelectRowAt indexPath: IndexPath) {
        viewModel.isPresented.value = false
    }
}

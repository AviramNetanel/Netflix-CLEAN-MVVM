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
    var items: Observable<[Valuable]> { get }
    var viewModel: CategoriesOverlayViewViewModel! { get }
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
    
    fileprivate(set) var items: Observable<[Valuable]> = .init([])
    fileprivate var viewModel: CategoriesOverlayViewViewModel!
    fileprivate let numberOfSections: Int = 1
    
    static func create(with viewModel: CategoriesOverlayViewViewModel) -> CategoriesOverlayViewTableViewDataSource {
        let dataSource = CategoriesOverlayViewTableViewDataSource()
        createViewModel(on: dataSource, with: viewModel)
        return dataSource
    }
    
    @discardableResult
    private static func createViewModel(on dataSource: CategoriesOverlayViewTableViewDataSource,
                                        with viewModel: CategoriesOverlayViewViewModel) -> CategoriesOverlayViewViewModel {
        dataSource.viewModel = viewModel
        return dataSource.viewModel
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { numberOfSections }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int { items.value.count }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return CategoriesOverlayViewTableViewCell.create(on: tableView,
                                                         for: indexPath,
                                                         with: items.value)
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
//        switch viewModel.
        print(viewModel.state)
        
        viewModel.isPresented.value = false
    }
}

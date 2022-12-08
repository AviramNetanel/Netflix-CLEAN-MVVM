//
//  CategoriesOverlayViewTableViewDataSource.swift
//  netflix
//
//  Created by Zach Bazov on 22/09/2022.
//

import UIKit

final class CategoriesOverlayViewTableViewDataSource: NSObject,
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
        
        let homeViewController = viewModel.coordinator.viewController
        let homeViewModel = homeViewController!.viewModel!
        let category = CategoriesOverlayView.Category(rawValue: indexPath.row)!
        let browseOverlayView = viewModel.coordinator.viewController!.browseOverlayView!
        let section: Section
        if viewModel.state == .categories {
            section = category.toSection(with: homeViewModel)
            browseOverlayView.dataSource = BrowseOverlayViewCollectionViewDataSource(section: section, with: homeViewModel)
            browseOverlayView.viewModel.isPresented = true
        }
        if viewModel.state == .mainMenu {
            if indexPath.row == 0 {
                print("tvshows")
                homeViewController?.navigationView.viewModel.state.value = .tvShows
            }
            if indexPath.row == 1 {
                print("movies")
                homeViewController?.navigationView.viewModel.state.value = .movies
            }
        }
    }
}

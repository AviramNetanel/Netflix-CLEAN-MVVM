//
//  CategoriesOverlayViewViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 20/09/2022.
//

import Foundation

final class CategoriesOverlayViewViewModel {
    let coordinator: HomeViewCoordinator
    
    private(set) var isPresented: Observable<Bool> = Observable(false)
    private(set) var navigationViewState: NavigationView.State = .home
    private(set) var state: CategoriesOverlayViewTableViewDataSource.State = .mainMenu
    private var category: CategoriesOverlayView.Category = .home
    private(set) var items: Observable<[Valuable]> = Observable([])
    
    init(with viewModel: HomeViewModel) {
        self.coordinator = viewModel.coordinator!
    }
    
    func itemsDidChange() {
        switch state {
        case .none:
            items.value = []
        case .mainMenu:
            let states = NavigationView.State.allCases[3...5].toArray()
            items.value = states
        case .categories:
            let categories = CategoriesOverlayView.Category.allCases
            items.value = categories
        }
    }
    
    func dataSourceDidChange() {
        let categoriesOverlay = coordinator.viewController?.categoriesOverlayView
        let tableView = categoriesOverlay?.tableView
        if tableView?.delegate == nil {
            tableView?.delegate = categoriesOverlay!.dataSource
            tableView?.dataSource = categoriesOverlay!.dataSource
        }
        
        tableView?.reloadData()
        
        tableView?.contentInset = .init(
            top: (categoriesOverlay!.bounds.height - tableView!.contentSize.height) / 2 - 80.0,
            left: .zero,
            bottom: (categoriesOverlay!.bounds.height - tableView!.contentSize.height) / 2,
            right: .zero)
    }
    
    func isPresentedDidChange() {
        let categoriesOverlay = coordinator.viewController?.categoriesOverlayView
        if case true = isPresented.value {
            categoriesOverlay?.isHidden(false)
            categoriesOverlay?.tableView.isHidden(false)
            categoriesOverlay?.footerView.isHidden(false)
            categoriesOverlay?.tabBar.isHidden(true)
            
            itemsDidChange()
            return
        }
        
        categoriesOverlay?.isHidden(true)
        categoriesOverlay?.footerView.isHidden(true)
        categoriesOverlay?.tableView.isHidden(true)
        categoriesOverlay?.tabBar.isHidden(true)
        
        categoriesOverlay?.tableView.delegate = nil
        categoriesOverlay?.tableView.dataSource = nil
    }
    
    func navigationViewStateDidChange(projectedValue state: NavigationView.State) {
        guard
            let homeViewController = coordinator.viewController,
            let homeViewModel = homeViewController.viewModel,
            let navigationView = homeViewController.navigationView
        else { return }
        
        navigationViewState = state
        
        switch state {
        case .home:
            guard homeViewModel.tableViewState.value != .all else {
                guard navigationView.homeItemView.viewModel.hasInteracted else {
                    print(1, isPresented.value)
                    return isPresented.value = false
                }
                print(2, isPresented.value)
                return isPresented.value = true
            }

            homeViewModel.tableViewState.value = .all
            self.state = .mainMenu
        case .tvShows:
            
            //
            
            
            
            if homeViewModel.tableViewState.value != .series {
                print("diff series")
            } else {
                print("equals series")
            }
            guard homeViewModel.tableViewState.value != .series else {
                guard navigationView.tvShowsItemView.viewModel.hasInteracted else {
                    print(1, "hasInteracted", navigationView.tvShowsItemView.viewModel.hasInteracted)
                    self.state = .mainMenu
                    return isPresented.value = false
                }
                print(2, "hasInteracted", navigationView.tvShowsItemView.viewModel.hasInteracted)
                self.state = .mainMenu
                return isPresented.value = true
            }
            print(3, "passed")
            homeViewModel.tableViewState.value = .series
            self.state = .mainMenu
        case .movies:
            guard homeViewModel.tableViewState.value != .films else {
                guard navigationView.moviesItemView.viewModel.hasInteracted else {
                    self.state = .mainMenu
                    return isPresented.value = false
                }
                self.state = .mainMenu
                return isPresented.value = true
            }

            homeViewModel.tableViewState.value = .films
            self.state = .mainMenu
        case .categories:
            isPresented.value = true
            self.state = .categories
        default: return
        }
    }
}

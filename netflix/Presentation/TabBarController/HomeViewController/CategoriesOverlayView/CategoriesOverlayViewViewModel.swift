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
    private(set) var items: Observable<[Valuable]> = Observable([])
    private var state: CategoriesOverlayViewTableViewDataSource.State = .mainMenu
    
    init(with viewModel: HomeViewModel) {
        self.coordinator = viewModel.coordinator!
    }
    
    private func itemsDidChange() {
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
        categoriesOverlay?.tabBar.isHidden(false)
        
        categoriesOverlay?.tableView.delegate = nil
        categoriesOverlay?.tableView.dataSource = nil
    }
    
    /// The `NavigationView` designed to contain two phases for navigation methods.
    /// Phase #1: First cycle of the navigation, switching between the navigation states,
    ///           simply by clicking (selecting) one of them.
    /// Phase #2: The expansion cycle of the navigation,
    ///           which controls the presentations of `CategoriesOverlayView` & `BrowseOverlayView`.
    ///           If needed, switch between the table view data-source's state
    ///           to display other data (e.g. series, films or all).
    /// - Parameter state: corresponding navigation's state value.
    func navigationViewStateDidChange(_ state: NavigationView.State) {
        guard let homeViewController = coordinator.viewController,
              let navigationView = homeViewController.navigationView,
              let browseOverlay = homeViewController.browseOverlayView else {
            return
        }
        
        switch state {
        case .home:
            /// - PHASE #1:
            /// In-case `homeItemView` hasn't been selected.
            if !navigationView.homeItemView.viewModel.isSelected {
                /// Change view selection.
                navigationView.homeItemView.viewModel.isSelected = true
                navigationView.tvShowsItemView.viewModel.isSelected = false
                navigationView.moviesItemView.viewModel.isSelected = false
                /// In-case `browseOverlayView` has been presented.
                if browseOverlay.viewModel.isPresented {
                    /// Hide the browser view.
                    browseOverlay.viewModel.isPresented = false
                    /// - PHASE #2:
                    /// Applys `NavigationView` state changes.
                    navigationView.viewModel.stateDidChange(Application.current.coordinator.coordinator.lastSelection ?? .home)
                    /// Based the navigation last selection, change selection settings.
                    if Application.current.coordinator.coordinator.lastSelection == .tvShows {
                        navigationView.homeItemView.viewModel.isSelected = false
                        navigationView.tvShowsItemView.viewModel.isSelected = true
                        navigationView.moviesItemView.viewModel.isSelected = false
                    } else if Application.current.coordinator.coordinator.lastSelection == .movies {
                        navigationView.homeItemView.viewModel.isSelected = false
                        navigationView.tvShowsItemView.viewModel.isSelected = false
                        navigationView.moviesItemView.viewModel.isSelected = true
                    }
                } else {
                    /// Reload a new view-controller instance.
                    Application.current.coordinator.replaceRootCoordinator()
                }
                /// Store state to property.
                Application.current.coordinator.coordinator.lastSelection = .home
            } else {
                /// In-case the browser view has been presented.
                if browseOverlay.viewModel.isPresented {
                    /// Hide the view.
                    browseOverlay.viewModel.isPresented = false
                }
            }
        case .tvShows:
            Application.current.coordinator.coordinator.lastSelection = .tvShows
            
            if !navigationView.tvShowsItemView.viewModel.isSelected {
                navigationView.homeItemView.viewModel.isSelected = false
                navigationView.tvShowsItemView.viewModel.isSelected = true
                navigationView.moviesItemView.viewModel.isSelected = false
                
                Application.current.coordinator.replaceRootCoordinator()
            } else {
                self.state = .mainMenu
                isPresented.value = true
            }
        case .movies:
            Application.current.coordinator.coordinator.lastSelection = .movies
            
            if !navigationView.moviesItemView.viewModel.isSelected {
                navigationView.homeItemView.viewModel.isSelected = false
                navigationView.tvShowsItemView.viewModel.isSelected = false
                navigationView.moviesItemView.viewModel.isSelected = true
                
                Application.current.coordinator.replaceRootCoordinator()
            } else {
                self.state = .mainMenu
                isPresented.value = true
            }
        case .categories:
            self.state = .categories
            isPresented.value = true
        default:
            break
        }
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        let homeViewController = coordinator.viewController
        let homeViewModel = homeViewController!.viewModel!
        let navigationView = homeViewController!.navigationView!
        let category = CategoriesOverlayView.Category(rawValue: indexPath.row)!
        let browseOverlayView = coordinator.viewController!.browseOverlayView!
        
        if state == .categories {
            let section = category.toSection(with: homeViewModel)
            browseOverlayView.dataSource = BrowseOverlayViewCollectionViewDataSource(
                section: section,
                with: homeViewModel)
            browseOverlayView.viewModel.isPresented = true
            
        } else if state == .mainMenu {
            guard let options = NavigationView.State.allCases[3...5].toArray()[indexPath.row] as NavigationView.State? else { return }
            
            if case .tvShows = options {
                if navigationView.viewModel.state.value == .tvShows { return }
                navigationView.viewModel.state.value = .tvShows
                navigationView.tvShowsItemView.viewModel.isSelected = false
                
                browseOverlayView.viewModel.isPresented = false
            } else if case .movies = options {
                if navigationView.viewModel.state.value == .movies { return }
                navigationView.viewModel.state.value = .movies
                navigationView.moviesItemView.viewModel.isSelected = false
                
                browseOverlayView.viewModel.isPresented = false
            } else {
                state = .categories
                isPresentedDidChange()
                isPresented.value = true
            }
        }
    }
}

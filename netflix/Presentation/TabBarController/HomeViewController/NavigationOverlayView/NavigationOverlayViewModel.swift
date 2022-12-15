//
//  NavigationOverlayViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 20/09/2022.
//

import Foundation

final class NavigationOverlayViewModel {
    let coordinator: HomeViewCoordinator
    
    private(set) var isPresented: Observable<Bool> = Observable(false)
    private(set) var items: Observable<[Valuable]> = Observable([])
    private var state: NavigationOverlayTableViewDataSource.State = .mainMenu
    
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
            let categories = NavigationOverlayView.Category.allCases
            items.value = categories
        }
    }
    
    func dataSourceDidChange() {
        guard let navigationOverlayView = coordinator.viewController?.navigationView?.navigationOverlayView else { return }
        
        let tableView = navigationOverlayView.tableView
        if tableView.delegate == nil {
            tableView.delegate = navigationOverlayView.dataSource
            tableView.dataSource = navigationOverlayView.dataSource
        }
        
        tableView.reloadData()
        tableView.contentInset = .init(
            top: (navigationOverlayView.bounds.height - tableView.contentSize.height) / 2 - 80.0,
            left: .zero,
            bottom: (navigationOverlayView.bounds.height - tableView.contentSize.height) / 2,
            right: .zero)
    }
    
    func isPresentedDidChange() {
        guard let navigationOverlayView = coordinator.viewController?.navigationView?.navigationOverlayView else { return }
        if case true = isPresented.value {
            navigationOverlayView.isHidden(false)
            navigationOverlayView.tableView.isHidden(false)
            navigationOverlayView.footerView.isHidden(false)
            navigationOverlayView.tabBar.isHidden(true)
            
            itemsDidChange()
            return
        }
        
        navigationOverlayView.isHidden(true)
        navigationOverlayView.footerView.isHidden(true)
        navigationOverlayView.tableView.isHidden(true)
        navigationOverlayView.tabBar.isHidden(false)
        
        navigationOverlayView.tableView.delegate = nil
        navigationOverlayView.tableView.dataSource = nil
    }
    
    /// The `NavigationView` designed to contain two phases for navigation methods.
    /// Phase #1: First cycle of the navigation, switching between the navigation states,
    ///           simply by clicking (selecting) one of them.
    /// Phase #2: The expansion cycle of the navigation,
    ///           which controls the presentations of `NavigationOverlayView` & `BrowseOverlayView`.
    ///           If needed, switch between the table view data-source's state
    ///           to display other data (e.g. series, films or all).
    /// - Parameter state: corresponding navigation's state value.
    func navigationViewStateDidChange(_ state: NavigationView.State) {
        guard let rootCoordinator = Application.current.coordinator as AppCoordinator?,
              let homeViewController = coordinator.viewController,
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
                /// - PHASE #2-A:
                /// Firstly, check for a case where the browser overlay is presented and home's table view
                /// data source state has been set to 'all' state.
                if browseOverlay.viewModel.isPresented && homeViewController.viewModel.tableViewState == .all {
                    /// In-case `browseOverlayView` has been presented, hide it.
                    browseOverlay.viewModel.isPresented = false
                    /// Apply `NavigationView` state changes.
                    navigationView.viewModel.stateDidChange(Application.current.coordinator.coordinator.lastSelection ?? .home)
                    /// Based the navigation last selection, change selection settings.
                    if rootCoordinator.coordinator.lastSelection == .tvShows {
                        navigationView.homeItemView.viewModel.isSelected = false
                        navigationView.tvShowsItemView.viewModel.isSelected = true
                        navigationView.moviesItemView.viewModel.isSelected = false
                    } else if Application.current.coordinator.coordinator.lastSelection == .movies {
                        navigationView.homeItemView.viewModel.isSelected = false
                        navigationView.tvShowsItemView.viewModel.isSelected = false
                        navigationView.moviesItemView.viewModel.isSelected = true
                    }
                } else {
                    /// - PHASE #2-B:
                    /// Secondly, check for a case where the browser overlay is presented.
                    /// and the navigation view state has been set to 'tvShows' or 'movies'.
                    if browseOverlay.viewModel.isPresented {
                        /// In-case the browser view has been presented, hide it.
                        browseOverlay.viewModel.isPresented = false
                        /// Apply navigation view state changes.
                        navigationView.viewModel.stateDidChange(Application.current.coordinator.coordinator.lastSelection)
                    } else {
                        /// Reload a new view-controller instance.
                        rootCoordinator.replaceRootCoordinator()
                    }
                }
            } else {
                /// - PHASE #2-C:
                /// Thirdly, check for a case where the browser overlay is presented.
                /// Otherwise, in-case where the `lastSelection` value
                /// is set to either 'tvShows' or 'movies', reset it and initiate re-coordination procedure.
                if browseOverlay.viewModel.isPresented {
                    browseOverlay.viewModel.isPresented = false
                } else {
                    /// In-case the last selection is either set to both media types states (series and films).
                    /// Initiate re-coordination procedure, and reset `lastSelection` value to home state.
                    if rootCoordinator.coordinator.lastSelection == .tvShows || rootCoordinator.coordinator.lastSelection == .movies {
                        /// Re-coordinate with a new view-controller instance.
                        rootCoordinator.replaceRootCoordinator()
                        /// Reset to home state.
                        rootCoordinator.coordinator.lastSelection = .home
                    } else {
                        /// Occurs once home state has been restored to the navigation view state,
                        /// and `browseOverlayView` view presentation is hidden.
                        /// Thus, this case represents the initial view's navigation state.
                    }
                }
            }
        case .tvShows:
            rootCoordinator.coordinator.lastSelection = .tvShows
            
            if !navigationView.tvShowsItemView.viewModel.isSelected {
                navigationView.homeItemView.viewModel.isSelected = false
                navigationView.tvShowsItemView.viewModel.isSelected = true
                navigationView.moviesItemView.viewModel.isSelected = false
                
                rootCoordinator.replaceRootCoordinator()
            } else {
                self.state = .mainMenu
                isPresented.value = true
            }
        case .movies:
            rootCoordinator.coordinator.lastSelection = .movies
            
            if !navigationView.moviesItemView.viewModel.isSelected {
                navigationView.homeItemView.viewModel.isSelected = false
                navigationView.tvShowsItemView.viewModel.isSelected = false
                navigationView.moviesItemView.viewModel.isSelected = true
                
                rootCoordinator.replaceRootCoordinator()
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
        let category = NavigationOverlayView.Category(rawValue: indexPath.row)!
        let browseOverlayView = coordinator.viewController!.browseOverlayView!
        
        if state == .categories {
            let section = category.toSection(with: homeViewModel)
            browseOverlayView.dataSource = BrowseOverlayCollectionViewDataSource(
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

//
//  NavigationViewViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 18/09/2022.
//

import Foundation

struct NavigationViewViewModelActions {
    let stateDidChange: (NavigationView.State) -> Void
}

final class NavigationViewViewModel {
    private let coordinator: HomeViewCoordinator
    let state: Observable<NavigationView.State>
    let items: [NavigationViewItem]
    let actions: NavigationViewViewModelActions
    
    init(items: [NavigationViewItem], actions: NavigationViewViewModelActions, with viewModel: HomeViewModel) {
        self.coordinator = viewModel.coordinator!
        self.state = Observable(.home)
        self.actions = actions
        self.items = items
    }
    
    func stateDidChange(projectedValue state: NavigationView.State) {
        let homeViewController = coordinator.viewController!
        homeViewController.navigationView?.categoriesItemView.viewDidConfigure(with: state)

        switch state {
        case .home:
            homeViewController.navigationView?.tvShowsItemViewContainer.isHidden(false)
            homeViewController.navigationView?.moviesItemViewContainer.isHidden(false)
            homeViewController.navigationView?.categoriesItemViewContainer.isHidden(false)
            homeViewController.navigationView?.itemsCenterXConstraint.constant = .zero

            homeViewController.navigationView?.tvShowsItemView.viewModel.hasInteracted = false
            homeViewController.navigationView?.moviesItemView.viewModel.hasInteracted = false
            
            /// BrowseOverlayView
            homeViewController.navigationViewContainer.backgroundColor = .clear
            homeViewController.browseOverlayView?.dataSource = nil
            homeViewController.browseOverlayView?.viewModel.isPresented = false
        case .airPlay:
            break
        case .account:
            break
        case .tvShows:
            homeViewController.navigationView?.tvShowsItemViewContainer.isHidden(false)
            homeViewController.navigationView?.moviesItemViewContainer.isHidden(true)
            homeViewController.navigationView?.categoriesItemViewContainer.isHidden(false)
            homeViewController.navigationView?.itemsCenterXConstraint.constant = -24.0

            homeViewController.navigationView?.tvShowsItemView.viewModel.hasInteracted = true
            
            homeViewController.navigationViewContainer.backgroundColor = .clear
        case .movies:
            homeViewController.navigationView?.tvShowsItemViewContainer.isHidden(true)
            homeViewController.navigationView?.moviesItemViewContainer.isHidden(false)
            homeViewController.navigationView?.categoriesItemViewContainer.isHidden(false)
            homeViewController.navigationView?.itemsCenterXConstraint.constant = -32.0
            
            homeViewController.navigationView?.moviesItemView.viewModel.hasInteracted = true
            
            homeViewController.navigationViewContainer.backgroundColor = .clear
        case .categories:
            break
        }
        
        homeViewController.navigationView?.animateUsingSpring(withDuration: 0.33, withDamping: 0.7, initialSpringVelocity: 0.7)
    }
}

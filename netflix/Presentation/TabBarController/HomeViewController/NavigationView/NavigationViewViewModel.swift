//
//  NavigationViewViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 18/09/2022.
//

import Foundation

struct NavigationViewViewModelActions {
    let navigationViewDidAppear: () -> Void
    let stateDidChange: (NavigationView.State) -> Void
}

final class NavigationViewViewModel {
    let coordinator: HomeViewCoordinator
    let state: Observable<NavigationView.State>
    let items: [NavigationViewItem]
    let actions: NavigationViewViewModelActions
    
    init(items: [NavigationViewItem],
         actions: NavigationViewViewModelActions,
         with viewModel: HomeViewModel) {
        self.coordinator = viewModel.coordinator!
        self.state = Observable(.home)
        self.actions = actions
        self.items = items
    }
    
    func navigationViewDidAppear() {
        let homeViewController = coordinator.viewController!
        homeViewController.navigationViewTopConstraint.constant = 0.0
        homeViewController.navigationView.alpha = 1.0
        homeViewController.view.animateUsingSpring(withDuration: 0.66, withDamping: 1.0, initialSpringVelocity: 1.0)
    }
    
    func stateDidChange(_ state: NavigationView.State) {
        let navigationView = coordinator.viewController!.navigationView!
        
        navigationView.categoriesItemView.viewDidConfigure(with: state)
        
        navigationView.animateUsingSpring(withDuration: 0.33,
                                          withDamping: 0.7,
                                          initialSpringVelocity: 0.7)

        switch state {
        case .home:
            navigationView.tvShowsItemViewContainer.isHidden(false)
            navigationView.moviesItemViewContainer.isHidden(false)
            navigationView.categoriesItemViewContainer.isHidden(false)
            navigationView.itemsCenterXConstraint.constant = .zero
        case .airPlay:
            break
        case .account:
            break
        case .tvShows:
            navigationView.tvShowsItemViewContainer.isHidden(false)
            navigationView.moviesItemViewContainer.isHidden(true)
            navigationView.categoriesItemViewContainer.isHidden(false)
            navigationView.itemsCenterXConstraint.constant = -24.0
        case .movies:
            navigationView.tvShowsItemViewContainer.isHidden(true)
            navigationView.moviesItemViewContainer.isHidden(false)
            navigationView.categoriesItemViewContainer.isHidden(false)
            navigationView.itemsCenterXConstraint.constant = -32.0
        case .categories:
            break
        }
    }
}

//
//  NavigationViewViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 18/09/2022.
//

import Foundation

// MARK: - NavigationViewViewModelActions struct

struct NavigationViewViewModelActions {
    let stateDidChange: (NavigationView.State) -> Void
}

// MARK: - ViewModelInput protocol

private protocol ViewModelInput {}

// MARK: - ViewModelOutput protocol

private protocol ViewModelOutput {
    var state: Observable<NavigationView.State> { get }
    var items: [NavigationViewItem] { get }
}

// MARK: - ViewModel typealias

private typealias ViewModel = ViewModelInput & ViewModelOutput

// MARK: - NavigationViewViewModel class

final class NavigationViewViewModel: ViewModel {
    
    let state: Observable<NavigationView.State>
    let items: [NavigationViewItem]
    let actions: NavigationViewViewModelActions
    
    init(items: [NavigationViewItem], actions: NavigationViewViewModelActions) {
        self.state = Observable(.home)
        self.actions = actions
        self.items = items
    }
    
    func stateDidChange(withOwner homeViewController: HomeViewController,
                        projectedValue state: NavigationView.State) {
        homeViewController.navigationView?.categoriesItemView.viewDidConfigure(with: state)

        switch state {
        case .home:
            homeViewController.navigationView?.tvShowsItemViewContainer.isHidden(false)
            homeViewController.navigationView?.moviesItemViewContainer.isHidden(false)
            homeViewController.navigationView?.categoriesItemViewContainer.isHidden(false)
            homeViewController.navigationView?.itemsCenterXConstraint.constant = .zero

            homeViewController.navigationView?.tvShowsItemView.viewModel.hasInteracted = false
            homeViewController.navigationView?.moviesItemView.viewModel.hasInteracted = false
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
        case .movies:
            homeViewController.navigationView?.tvShowsItemViewContainer.isHidden(true)
            homeViewController.navigationView?.moviesItemViewContainer.isHidden(false)
            homeViewController.navigationView?.categoriesItemViewContainer.isHidden(false)
            homeViewController.navigationView?.itemsCenterXConstraint.constant = -32.0
            
            homeViewController.navigationView?.moviesItemView.viewModel.hasInteracted = true
        case .categories:
            break
        }
        
        homeViewController.navigationView?.animateUsingSpring(withDuration: 0.33, withDamping: 0.7, initialSpringVelocity: 0.7)
    }
}

//
//  CategoriesOverlayViewViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 20/09/2022.
//

import Foundation

// MARK: - ViewModelInput protocol

private protocol ViewModelInput {
    var isPresentedDidChange: (() -> Void)? { get }
}

// MARK: - ViewModelOutput protocol

private protocol ViewModelOutput {
    var isPresented: Observable<Bool> { get }
//    var state: NavigationView.State { get }
    var category: CategoriesOverlayView.Category { get }
}

// MARK: - ViewModel typealias

private typealias ViewModel = ViewModelInput & ViewModelOutput

// MARK: - CategoriesOverlayViewViewModel class

final class CategoriesOverlayViewViewModel: ViewModel {
    
    fileprivate(set) var isPresented: Observable<Bool> = Observable(false)
    var navigationViewState: NavigationView.State = .tvShows
    var state: CategoriesOverlayViewTableViewDataSource.State = .mainMenu
    fileprivate var category: CategoriesOverlayView.Category = .home
    fileprivate(set) var items: Observable<[Valuable]> = Observable([])
    var isPresentedDidChange: (() -> Void)?
    
    deinit { isPresentedDidChange = nil }
    
    func stateDidChange(homeViewController: HomeViewController, state: NavigationView.State) {
        homeViewController.categoriesOverlayView.viewModel.navigationViewState = state
        
        switch state {
        case .home:
            guard homeViewController.viewModel.tableViewState.value != .all else {
                guard homeViewController.navigationView.homeItemView.viewModel.hasInteracted else {
                    return homeViewController.categoriesOverlayView.viewModel.isPresented.value = false
                }
                return homeViewController.categoriesOverlayView.viewModel.isPresented.value = true
            }

            homeViewController.viewModel.tableViewState.value = .all
            homeViewController.categoriesOverlayView.viewModel.state = .mainMenu
        case .tvShows:
            guard homeViewController.viewModel.tableViewState.value != .series else {
                guard homeViewController.navigationView.tvShowsItemView.viewModel.hasInteracted else {
                    homeViewController.categoriesOverlayView.viewModel.state = .mainMenu
                    return homeViewController.categoriesOverlayView.viewModel.isPresented.value = false
                }
                homeViewController.categoriesOverlayView.viewModel.state = .mainMenu
                return homeViewController.categoriesOverlayView.viewModel.isPresented.value = true
            }

            homeViewController.viewModel.tableViewState.value = .series
            homeViewController.categoriesOverlayView.viewModel.state = .mainMenu
        case .movies:
            guard homeViewController.viewModel.tableViewState.value != .films else {
                guard homeViewController.navigationView.moviesItemView.viewModel.hasInteracted else {
                    homeViewController.categoriesOverlayView.viewModel.state = .mainMenu
                    return homeViewController.categoriesOverlayView.viewModel.isPresented.value = false
                }
                homeViewController.categoriesOverlayView.viewModel.state = .mainMenu
                return homeViewController.categoriesOverlayView.viewModel.isPresented.value = true
            }

            homeViewController.viewModel.tableViewState.value = .films
            homeViewController.categoriesOverlayView.viewModel.state = .mainMenu
        case .categories:
            homeViewController.categoriesOverlayView.viewModel.isPresented.value = true
            homeViewController.categoriesOverlayView.viewModel.state = .categories
        default: return
        }
    }
    
    func stateDidChangeOnViewModel(homeViewController: HomeViewController, state: NavigationView.State) {
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

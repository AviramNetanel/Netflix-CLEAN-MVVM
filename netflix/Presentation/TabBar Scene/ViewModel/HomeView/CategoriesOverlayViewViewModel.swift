//
//  CategoriesOverlayViewViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 20/09/2022.
//

import Foundation

// MARK: - ViewModelInput protocol

private protocol ViewModelInput {
    
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
    var navigationViewState: NavigationView.State = .home
    var state: CategoriesOverlayViewTableViewDataSource.State = .mainMenu
    fileprivate var category: CategoriesOverlayView.Category = .home
    fileprivate(set) var items: Observable<[Valuable]> = Observable([])
    
    func navigationViewStateDidChange(withOwner homeViewController: HomeViewController, projectedValue state: NavigationView.State) {
        navigationViewState = state
        
        switch state {
        case .home:
            guard homeViewController.viewModel.tableViewState.value != .all else {
                guard homeViewController.navigationView.homeItemView.viewModel.hasInteracted else {
                    return isPresented.value = false
                }
                return isPresented.value = true
            }

            homeViewController.viewModel.tableViewState.value = .all
            self.state = .mainMenu
        case .tvShows:
            guard homeViewController.viewModel.tableViewState.value != .series else {
                guard homeViewController.navigationView.tvShowsItemView.viewModel.hasInteracted else {
                    self.state = .mainMenu
                    return isPresented.value = false
                }
                self.state = .mainMenu
                return isPresented.value = true
            }

            homeViewController.viewModel.tableViewState.value = .series
            self.state = .mainMenu
        case .movies:
            guard homeViewController.viewModel.tableViewState.value != .films else {
                guard homeViewController.navigationView.moviesItemView.viewModel.hasInteracted else {
                    self.state = .mainMenu
                    return isPresented.value = false
                }
                self.state = .mainMenu
                return isPresented.value = true
            }

            homeViewController.viewModel.tableViewState.value = .films
            self.state = .mainMenu
        case .categories:
            isPresented.value = true
            self.state = .categories
        default: return
        }
    }
}

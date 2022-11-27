//
//  NavigationViewViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 18/09/2022.
//

import Foundation

// MARK: - NavigationViewViewModelActions struct

struct NavigationViewViewModelActions {
    let stateDidChangeOnViewModel: (HomeViewController, NavigationView.State) -> Void
    let stateDidChangeOnViewController: (HomeViewController, NavigationView.State) -> Void
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
        self.actions = actions
        self.items = items
        self.state = Observable(.home)
    }
}

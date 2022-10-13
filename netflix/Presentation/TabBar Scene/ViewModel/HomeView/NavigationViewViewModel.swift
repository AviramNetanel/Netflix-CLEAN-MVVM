//
//  NavigationViewViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 18/09/2022.
//

import Foundation

// MARK: - ViewModelInput protocol

private protocol ViewModelInput {
    var stateDidChangeDidBindToViewModel: ((NavigationView.State) -> Void)? { get }
}

// MARK: - ViewModelOutput protocol

private protocol ViewModelOutput {
    var state: Observable<NavigationView.State> { get }
    var items: [NavigationViewItem] { get }
}

// MARK: - ViewModel typealias

private typealias ViewModel = ViewModelInput & ViewModelOutput

// MARK: - NavigationViewViewModel class

final class NavigationViewViewModel: ViewModel {
    
    fileprivate(set) var state: Observable<NavigationView.State>
    fileprivate(set) var items: [NavigationViewItem]
    
    var stateDidChangeDidBindToViewModel: ((NavigationView.State) -> Void)?
    
    init(items: [NavigationViewItem]) {
        self.items = items
        self.state = .init(.home)
    }
    
    deinit { stateDidChangeDidBindToViewModel = nil }
}

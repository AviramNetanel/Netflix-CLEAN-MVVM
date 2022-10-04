//
//  NavigationViewViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 18/09/2022.
//

import Foundation

// MARK: - ViewModelInput protocol

private protocol ViewModelInput {
    var state: Observable<NavigationView.State> { get }
    var items: [NavigationViewItem] { get }
}

// MARK: - ViewModelOutput protocol

private protocol ViewModelOutput {
    func _stateDidChange(state: NavigationView.State)
}

// MARK: - ViewModel typealias

private typealias ViewModel = ViewModelInput & ViewModelOutput

// MARK: - NavigationViewViewModel class

final class NavigationViewViewModel: ViewModel {
    
    fileprivate(set) var state: Observable<NavigationView.State>
    fileprivate var items: [NavigationViewItem]
    
    var stateDidChange: ((NavigationView.State) -> Void)?
    
    init(with items: [NavigationViewItem],
         for state: NavigationView.State) {
        self.items = items
        self.state = .init(state)
        self.setupBindings()
        self.setupObservers()
    }
    
    deinit { stateDidChange = nil }
    
    private func setupBindings() {
        buttonDidTap(for: items)
    }
    
    private func setupObservers() {
        state.observe(on: self) { [weak self] state in self?._stateDidChange(state: state) }
    }
    
    private func buttonDidTap(for items: [NavigationViewItem]) {
        items.forEach { $0.configuration.buttonDidTap = { [weak self] state in self?.state.value = state } }
    }
    
    fileprivate func _stateDidChange(state: NavigationView.State) {
        stateDidChange?(state)
    }
    
    func removeObservers() {
        printIfDebug("Removed `DefaultNavigationViewViewModel` observers.")
        state.remove(observer: self)
    }
}

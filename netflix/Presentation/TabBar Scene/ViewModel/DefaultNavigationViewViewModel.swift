//
//  DefaultNavigationViewViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 18/09/2022.
//

import Foundation

// MARK - NavigationViewViewModelInput protocol

private protocol NavigationViewViewModelInput {
    var state: Observable<DefaultNavigationView.State> { get }
    var items: [NavigationViewItem] { get }
}

// MARK - NavigationViewViewModelOutput protocol

private protocol NavigationViewViewModelOutput {
    func _stateDidChange(state: DefaultNavigationView.State)
}

// MARK - NavigationViewViewModel protocol

private protocol NavigationViewViewModel: NavigationViewViewModelInput,
                                          NavigationViewViewModelOutput {}

// MARK - DefaultNavigationViewViewModel class

final class DefaultNavigationViewViewModel: NavigationViewViewModel {
    
    fileprivate var state: Observable<DefaultNavigationView.State>
    fileprivate var items: [NavigationViewItem]
    
    var stateDidChange: ((DefaultNavigationView.State) -> Void)?
    
    init(with items: [NavigationViewItem],
         for state: DefaultNavigationView.State) {
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
    
    fileprivate func _stateDidChange(state: DefaultNavigationView.State) {
        stateDidChange?(state)
    }
    
    func removeObservers() {
        printIfDebug("Removed `DefaultNavigationViewViewModel` observers.")
        state.remove(observer: self)
    }
}

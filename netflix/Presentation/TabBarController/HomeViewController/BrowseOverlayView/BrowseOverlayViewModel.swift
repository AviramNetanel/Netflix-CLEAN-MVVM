//
//  BrowseOverlayViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 07/12/2022.
//

import Foundation

final class BrowseOverlayViewModel {
    private let coordinator: HomeViewCoordinator
    
    init(with viewModel: HomeViewModel) {
        self.coordinator = viewModel.coordinator!
    }
    
    var isPresented = false {
        didSet { shouldDisplayOrHide() }
    }
    
    private func shouldDisplayOrHide() {
        guard let homeViewController = coordinator.viewController else { return }
        
        if isPresented {
            homeViewController.view.animateUsingSpring(
                withDuration: 0.5,
                withDamping: 1.0,
                initialSpringVelocity: 0.7,
                animations: {
                    homeViewController.navigationViewContainer.backgroundColor = .black
                    homeViewController.browseOverlayViewContainer.alpha = 1.0
                })
            return
        }
        
        homeViewController.view.animateUsingSpring(
            withDuration: 0.5,
            withDamping: 1.0,
            initialSpringVelocity: 0.7,
            animations: {
                homeViewController.navigationViewContainer.backgroundColor = .clear
                homeViewController.browseOverlayViewContainer.alpha = .zero
            })
    }
}

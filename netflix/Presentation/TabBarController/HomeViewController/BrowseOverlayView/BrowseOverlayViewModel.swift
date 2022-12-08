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
        guard !isPresented else {
            coordinator.viewController?.navigationViewContainer.backgroundColor = .black
            
            coordinator.viewController?.browseOverlayViewContainer.isHidden(false)
            coordinator.viewController?.browseOverlayBottomConstraint.constant = .zero
            return
        }
        coordinator.viewController?.navigationViewContainer.backgroundColor = .clear
        
        coordinator.viewController?.browseOverlayViewContainer.isHidden(true)
        coordinator.viewController?.browseOverlayBottomConstraint.constant = coordinator.viewController!.browseOverlayViewContainer.bounds.size.height
    }
}

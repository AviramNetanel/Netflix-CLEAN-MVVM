//
//  HomeFlowCoordinator.swift
//  netflix
//
//  Created by Zach Bazov on 06/09/2022.
//

import UIKit

// MARK: - HomeFlowCoordinatorDependencies protocol

protocol HomeFlowCoordinatorDependencies {
    func createHomeViewController(actions: HomeViewModelActions) -> HomeViewController
}

// MARK: - HomeFlowCoordinator class

final class HomeFlowCoordinator {
    
    private let dependencies: HomeFlowCoordinatorDependencies
    
    private weak var navigationController: UINavigationController?
    private weak var viewController: UIViewController?
    
    init(navigationController: UINavigationController,
         dependencies: HomeFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func coordinate() {
        let actions = HomeViewModelActions(presentMediaDetails: presentMediaDetails)
        let viewController = dependencies.createHomeViewController(actions: actions)
        
        self.viewController = viewController
    }
    
    // MARK: Private
    
    private func presentMediaDetails(media: Media) {
        viewController?.performSegue(withIdentifier: String(describing: DetailViewController.self),
                                     sender: viewController)
    }
}

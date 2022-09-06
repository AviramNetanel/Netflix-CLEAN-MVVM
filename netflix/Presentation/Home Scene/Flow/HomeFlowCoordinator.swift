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
    
    init(navigationController: UINavigationController, dependencies: HomeFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func coordinate() {
        let actions = HomeViewModelActions()
        
        let viewController = dependencies.createHomeViewController(actions: actions)
        
        navigationController?.pushViewController(viewController, animated: false)
        
        self.viewController = viewController
    }
    
    // MARK: Private
    
    
}

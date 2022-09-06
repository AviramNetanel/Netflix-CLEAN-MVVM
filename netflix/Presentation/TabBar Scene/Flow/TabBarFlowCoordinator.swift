//
//  TabBarFlowCoordinator.swift
//  netflix
//
//  Created by Zach Bazov on 06/09/2022.
//

import UIKit

// MARK: - TabBarFlowCoordinatorDependencies protocol

protocol TabBarFlowCoordinatorDependencies {
    func createHomeViewController(actions: HomeViewModelActions) -> HomeTableViewController
    func createTabBarController(actions: HomeViewModelActions) -> HomeTabBarController
}

// MARK: - TabBarFlowCoordinator class

final class TabBarFlowCoordinator {
    
    private let dependencies: TabBarFlowCoordinatorDependencies
    
    private weak var navigationController: UINavigationController?
    private weak var viewController: UIViewController?
    
    init(navigationController: UINavigationController, dependencies: TabBarFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func coordinate() {
        let actions = HomeViewModelActions()
        let viewController = dependencies.createTabBarController(actions: actions)
        
        navigationController?.pushViewController(viewController, animated: false)
        
        self.viewController = viewController
    }
    
    // MARK: Private
    
    
}

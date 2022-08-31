//
//  HomeFlowCoordinator.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import UIKit

protocol HomeCoordinatorDependencies {
    func instantiateHomeViewController() -> HomeViewController
}

final class HomeFlowCoordinator {
    
    private let dependencies: HomeCoordinatorDependencies
    private weak var navigationController: UINavigationController?
    private weak var homeViewController: HomeViewController?
    
    init(navigationController: UINavigationController, dependencies: HomeCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let viewController = dependencies.instantiateHomeViewController()
        navigationController?.pushViewController(viewController, animated: false)
        homeViewController = viewController
    }
}

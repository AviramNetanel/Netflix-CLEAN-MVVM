//
//  HomeSceneDIContainer.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import UIKit

final class HomeDependencies {
    
    struct Dependencies {
        
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeHomeFlowCoordinator(navigationController: UINavigationController) -> HomeFlowCoordinator {
        return HomeFlowCoordinator(navigationController: navigationController, dependencies: self)
    }
}

extension HomeDependencies: HomeCoordinatorDependencies {
    func instantiateHomeViewController() -> HomeViewController {
        return HomeViewController()
    }
}

extension HomeDependencies: Dependable {}

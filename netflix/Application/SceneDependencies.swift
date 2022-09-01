//
//  SceneDependencies.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import UIKit

// MARK: - SceneDependable protocol

protocol SceneDependable {
    func createFlowCoordinator(navigationController: UINavigationController) -> FlowCoordinator
}

// MARK: - SceneDependencies class

final class SceneDependencies {
    
    struct Dependencies {
        fileprivate let viewControllers = ViewControllers()
        let dataTransferService: DataTransferService
    }
    
    fileprivate struct ViewControllers {
        lazy var authViewController = AuthViewController()
        lazy var homeViewController = HomeViewController()
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

// MARK: - Dependable implementation

extension SceneDependencies: Dependable {}

// MARK: - SceneDependable implementation

extension SceneDependencies: SceneDependable {
    func createFlowCoordinator(navigationController: UINavigationController) -> FlowCoordinator {
        return FlowCoordinator(navigationController: navigationController, dependencies: self)
    }
}

// MARK: - FlowCoordinatorDependencies implementation

extension SceneDependencies: FlowCoordinatorDependencies {
    func instantiateViewController(for scene: FlowCoordinator.Scene) -> UIViewController {
        var viewControllers = dependencies.viewControllers
        return scene == .auth ? viewControllers.authViewController : viewControllers.homeViewController
    }
}

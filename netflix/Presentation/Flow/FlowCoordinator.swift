//
//  FlowCoordinator.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import UIKit

// MARK: - FlowCoordinatorDependencies protocol

protocol FlowCoordinatorDependencies {
    func instantiateViewController(for scene: FlowCoordinator.Scene) -> UIViewController
}

// MARK: - FlowCoordinator class

final class FlowCoordinator {
    
    enum Scene {
        case auth
        case home
    }
    
    private var scene: Scene = .auth
    private let dependencies: FlowCoordinatorDependencies
    private weak var navigationController: UINavigationController?
    private weak var viewController: UIViewController?
    
    init(navigationController: UINavigationController, dependencies: FlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func coordinate() {
        let viewController = dependencies.instantiateViewController(for: scene)
        navigationController?.pushViewController(viewController, animated: false)
        self.viewController = viewController
    }
    
    func coordinate(to scene: Scene) {
        let viewController = dependencies.instantiateViewController(for: scene)
        navigationController?.pushViewController(viewController, animated: false)
        self.viewController = viewController
    }
}

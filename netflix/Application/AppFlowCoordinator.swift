//
//  AppFlowCoordinator.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import UIKit

// MARK: - FlowCoordinating protocol

protocol FlowCoordinating {
    func createSceneFlow()
}

// MARK: - AppFlowCoordinator class

final class AppFlowCoordinator {
    
    private let dependencies: AppDependencies
    private var navigationController: UINavigationController
    
    init(navigationController: UINavigationController, dependencies: AppDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
}

// MARK: - FlowCoordinating implementation

extension AppFlowCoordinator: FlowCoordinating {
    
    func createSceneFlow() {
        let sceneDependencies = dependencies.createSceneDependencies() as! SceneDependencies
        let flowCoordinator = sceneDependencies.createFlowCoordinator(navigationController: navigationController)
        flowCoordinator.coordinate()
    }
}

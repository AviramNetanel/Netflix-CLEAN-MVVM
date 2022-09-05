//
//  AppFlowCoordinator.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import UIKit

// MARK: - AppFlowCoordinator class

final class AppFlowCoordinator {
    
    private let appDependencies: AppDependencies
    private var navigationController: UINavigationController
    
    init(navigationController: UINavigationController, dependencies: AppDependencies) {
        self.navigationController = navigationController
        self.appDependencies = dependencies
    }
    
    func createSceneFlow() {
        let sceneDependencies = appDependencies.createSceneDependencies()
        let flowCoordinator = sceneDependencies.createFlowCoordinator(navigationController: navigationController)
        flowCoordinator.coordinate()
    }
}

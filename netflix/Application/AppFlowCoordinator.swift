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
    
    init(navigationController: UINavigationController, appDependencies: AppDependencies = AppDependencies()) {
        self.navigationController = navigationController
        self.appDependencies = appDependencies
    }
    
    func createAuthSceneFlow() {
        let sceneDependencies = appDependencies.createSceneDependencies()
        let flowCoordinator = sceneDependencies.createAuthFlowCoordinator(navigationController: navigationController)
        flowCoordinator.coordinate()
    }
    
    func createTabBarSceneFlow() {
        let sceneDependencies = appDependencies.createSceneDependencies()
        let flowCoordinator = sceneDependencies.createTabBarFlowCoordinator(navigationController: navigationController)
        flowCoordinator.coordinate()
    }
}

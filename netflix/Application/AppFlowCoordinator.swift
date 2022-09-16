//
//  AppFlowCoordinator.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import UIKit

// MARK: - AppFlowCoordinator class

final class AppFlowCoordinator {
    
    private var appDependencies: AppDependencies
    private(set) var sceneDependencies: SceneDependencies
    private(set) var navigationController: UINavigationController
    private(set) var homeFlowCoordinator: HomeFlowCoordinator!
    
    init(navigationController: UINavigationController,
         appDependencies: AppDependencies = AppDependencies()) {
        self.navigationController = navigationController
        self.appDependencies = appDependencies
        self.sceneDependencies = appDependencies.createSceneDependencies()
    }
    
    func createAuthSceneFlow() {
        let flowCoordinator = sceneDependencies.createAuthFlowCoordinator(
            navigationController: navigationController)
        flowCoordinator.coordinate()
    }
    
    func createHomeSceneFlow() {
        homeFlowCoordinator = sceneDependencies.createHomeFlowCoordinator(
            navigationController: navigationController)
        homeFlowCoordinator.coordinate()
    }
}

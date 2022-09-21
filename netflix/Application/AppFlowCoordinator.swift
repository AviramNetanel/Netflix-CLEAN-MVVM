//
//  AppFlowCoordinator.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import UIKit

// MARK: - AppFlowCoordinating protocol

protocol AppFlowCoordinating {
    func create(for scene: AppFlowCoordinator.SceneFlow)
}

// MARK: - AppFlowCoordinator class

final class AppFlowCoordinator {
    
    enum SceneFlow {
        case auth
        case home
    }
    
    private var appDependencies: AppDependencies
    private(set) var sceneDependencies: SceneDependencies
    private(set) var navigationController: UINavigationController
    private(set) var authFlowCoordinator: AuthFlowCoordinator?
    private(set) var homeFlowCoordinator: HomeFlowCoordinator?
    
    init(navigationController: UINavigationController,
         appDependencies: AppDependencies = AppDependencies()) {
        self.navigationController = navigationController
        self.appDependencies = appDependencies
        self.sceneDependencies = appDependencies.createSceneDependencies()
    }
}

// MARK: - AppFlowCoordinating implementation

extension AppFlowCoordinator: AppFlowCoordinating {
    
    func create(for sceneFlow: SceneFlow) {
        switch sceneFlow {
        case .auth:
            authFlowCoordinator = sceneDependencies
                .createAuthFlowCoordinator(navigationController: navigationController)
                .coordinate()
        case .home:
            homeFlowCoordinator = sceneDependencies
                .createHomeFlowCoordinator(navigationController: navigationController)
                .coordinate()
        }
    }
}

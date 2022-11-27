//
//  AppFlowCoordinator.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import UIKit

// MARK: - FlowDependencies protocol

protocol FlowDependencies {
    func createAuthFlowCoordinator(navigationController: UINavigationController,
                                   appFlowDependencies: AppFlowCoordinatorDependencies) -> AuthFlowCoordinator
    func createHomeFlowCoordinator(navigationController: UINavigationController) -> TabBarFlowCoordinator
}

// MARK: - FlowCoordinatorInput protocol

protocol FlowCoordinatorInput {
    func launch()
    func coordinate()
    func sceneDidDisconnect()
}

// MARK: - AppFlowCoordinatorDependencies protocol

protocol AppFlowCoordinatorDependencies {
    func createAuthSceneFlow()
    func createHomeSceneFlow()
}

// MARK: - AppFlowCoordinator class

final class AppFlowCoordinator {
    
    private(set) lazy var navigationController = UINavigationController()
    private(set) lazy var appSceneDIProvider = AppSceneDIProvider(appFlowCoordinator: self)
    
    private(set) lazy var authFlowCoordinator = appSceneDIProvider
        .createAuthFlowCoordinator(navigationController: navigationController, appFlowDependencies: self)
    private(set) lazy var homeFlowCoordinator = appSceneDIProvider
        .createHomeFlowCoordinator(navigationController: navigationController)
}

// MARK: - AppFlowCoordinatorDependencies implementation

extension AppFlowCoordinator: AppFlowCoordinatorDependencies {
    
    func createAuthSceneFlow() {
        authFlowCoordinator.launch()
        authFlowCoordinator.coordinate()
    }
    
    func createHomeSceneFlow() {
        homeFlowCoordinator.launch()
        homeFlowCoordinator.coordinate()
    }
}

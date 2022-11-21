//
//  AppFlowCoordinator.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import UIKit

// MARK: - FlowCoordinatorInput protocol

protocol FlowCoordinatorInput {
    func create()
    func coordinate()
    func sceneDidDisconnect()
}

// MARK: - AppFlowCoordinatorDependencies protocol

private protocol AppFlowCoordinatorDependencies {
    func createAuthSceneFlow()
    func createHomeSceneFlow()
}

// MARK: - AppFlowCoordinator class

final class AppFlowCoordinator {
    
    private(set) var appDependencies: AppDependencies
    private let sceneDependencies: SceneDependencies
    private let navigationController: UINavigationController
    private lazy var authFlowCoordinator: AuthFlowCoordinator = sceneDependencies
.createAuthFlowCoordinator(appFlowCoordinator: self, navigationController: navigationController)
    private(set) lazy var homeFlowCoordinator: HomeFlowCoordinator = sceneDependencies
        .createHomeFlowCoordinator(navigationController: navigationController)
    
    init(navigationController: UINavigationController,
         appDependencies: AppDependencies = AppDependencies()) {
        self.navigationController = navigationController
        self.appDependencies = appDependencies
        self.sceneDependencies = appDependencies.createSceneDependencies()
    }
}

// MARK: - AppFlowCoordinatorDependencies implementation

extension AppFlowCoordinator: AppFlowCoordinatorDependencies {
    
    func createAuthSceneFlow() { authFlowCoordinator.coordinate() }
    
    func createHomeSceneFlow() { homeFlowCoordinator.coordinate() }
}

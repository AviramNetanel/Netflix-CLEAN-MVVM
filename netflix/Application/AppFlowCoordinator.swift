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
    private var flowCoordinator: FlowCoordinator!
    
    init(navigationController: UINavigationController, dependencies: AppDependencies) {
        self.navigationController = navigationController
        self.appDependencies = dependencies
    }
    
    func createSceneFlow() {
        let sceneDependencies = appDependencies.createSceneDependencies()
        flowCoordinator = sceneDependencies.createFlowCoordinator(navigationController: navigationController)
        flowCoordinator.coordinate(to: .auth)
    }
}

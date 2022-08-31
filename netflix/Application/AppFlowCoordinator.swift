//
//  AppFlowCoordinator.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import UIKit

final class AppFlowCoordinator {
    
    var navigationController: UINavigationController
    private let appDependencies: DefaultAppDependencies
    
    init(navigationController: UINavigationController, appDependencies: DefaultAppDependencies) {
        self.navigationController = navigationController
        self.appDependencies = appDependencies
    }
    
    func start() {
        let homeSceneDIContainer = appDependencies.createScene(for: .home) as! HomeDependencies
        let flow = homeSceneDIContainer.makeHomeFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
}

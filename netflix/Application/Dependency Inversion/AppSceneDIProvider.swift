//
//  AppSceneDIProvider.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import UIKit.UINavigationController

// MARK: - AppSceneDIProvider class

final class AppSceneDIProvider {
    
    private(set) weak var appFlowCoordinator: AppFlowCoordinator!
    
    private lazy var configuration = AppConfiguration()
    
    private(set) lazy var dataTransferService: DataTransferService = {
        let url = URL(string: configuration.apiScheme + "://" + configuration.apiHost)!
        let config = NetworkConfig(baseURL: url)
        let networkService = NetworkService(config: config)
        return DataTransferService(with: networkService)
    }()
    
    private(set) lazy var authService = AuthService()
    
    private(set) lazy var authResponseCache: AuthResponseStorage = AuthResponseStorage(authService: authService)
    private(set) lazy var mediaResponseCache: MediaResponseStorage = MediaResponseStorage()
    
    private(set) lazy var authSceneDIProvider = AuthSceneDIProvider(appFlowCoordinator: appFlowCoordinator)
    private(set) lazy var tabBarSceneDIProvider = TabBarSceneDIProvider(appFlowCoordinator: appFlowCoordinator)
    
    init(appFlowCoordinator: AppFlowCoordinator) {
        self.appFlowCoordinator = appFlowCoordinator
    }
}

// MARK: - FlowDependencies implementation

extension AppSceneDIProvider: FlowDependencies {
    
    func createAuthFlowCoordinator(navigationController: UINavigationController,
                                   appFlowDependencies: AppFlowCoordinatorDependencies) -> AuthFlowCoordinator {
        return AuthFlowCoordinator(appFlowDependencies: appFlowDependencies,
                                   navigationController: navigationController,
                                   dependencies: authSceneDIProvider)
    }
    
    func createHomeFlowCoordinator(navigationController: UINavigationController) -> TabBarFlowCoordinator {
        return TabBarFlowCoordinator(navigationController: navigationController,
                                   dependencies: tabBarSceneDIProvider)
    }
}

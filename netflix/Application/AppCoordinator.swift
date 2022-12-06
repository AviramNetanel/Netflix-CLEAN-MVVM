//
//  AppCoordinator.swift
//  netflix
//
//  Created by Zach Bazov on 05/12/2022.
//

import UIKit

// MARK: - AppCoordinator class

final class AppCoordinator: Coordinate {
    
    enum Screen {
        case auth
        case tabBar
    }
    
    private(set) lazy var configuration = AppConfiguration()
    private(set) var authService = AuthService()
    private(set) lazy var dataTransferService: DataTransferService = {
        let url = URL(string: configuration.apiScheme + "://" + configuration.apiHost)!
        let config = NetworkConfig(baseURL: url)
        let networkService = NetworkService(config: config)
        return DataTransferService(with: networkService)
    }()
    private(set) lazy var authResponseCache: AuthResponseStorage = AuthResponseStorage(authService: authService)
    private(set) lazy var mediaResponseCache: MediaResponseStorage = MediaResponseStorage()
    
    weak var viewController: UIViewController?
    weak var window: UIWindow? {
        didSet {
            viewController = window?.rootViewController
        }
    }
    
    func showScreen(_ screen: Screen) {
        switch screen {
        case .auth:
            let coordinator = AuthCoordinator()
            let viewModel = AuthViewModel()
            let controller = AuthController()
            
            coordinator.viewController = controller
            viewModel.coordinator = coordinator
            controller.viewModel = viewModel
            
            controller.setNavigationBarHidden(false, animated: false)
            
            window?.rootViewController = controller
            
            coordinator.showScreen(.intro)
        case .tabBar:
            let tabBar = TabBarController()
            let viewModel = TabBarViewModel()
            let coordinator = TabBarCoordinator()

            coordinator.viewController = tabBar
            viewModel.coordinator = coordinator
            tabBar.viewModel = viewModel
            
            window?.rootViewController = tabBar
            
            coordinator.auth()
        }
    }
}

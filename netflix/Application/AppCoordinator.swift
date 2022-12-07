//
//  AppCoordinator.swift
//  netflix
//
//  Created by Zach Bazov on 05/12/2022.
//

import UIKit

final class AppCoordinator: Coordinate {
    enum Screen {
        case auth
        case tabBar
    }
    
    weak var viewController: UIViewController?
    weak var window: UIWindow? {
        didSet {
            viewController = window?.rootViewController
        }
    }
    
    func showScreen(_ screen: Screen) {
        if case .auth = screen {
            let coordinator = AuthCoordinator()
            let viewModel = AuthViewModel()
            let controller = AuthController()
            
            coordinator.viewController = controller
            viewModel.coordinator = coordinator
            controller.viewModel = viewModel
            
            controller.setNavigationBarHidden(false, animated: false)
            
            window?.rootViewController = controller
            coordinator.showScreen(.intro)
            
        } else if case .tabBar = screen {
            let tabBar = TabBarController()
            let viewModel = TabBarViewModel()
            let coordinator = TabBarCoordinator()

            coordinator.viewController = tabBar
            viewModel.coordinator = coordinator
            tabBar.viewModel = viewModel
            
            window?.rootViewController = tabBar
            coordinator.requestUserCredentials()
        }
    }
}

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
    
    var coordinator: TabBarCoordinator!
    
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
            coordinator = TabBarCoordinator()

            coordinator.viewController = tabBar
            viewModel.coordinator = coordinator
            tabBar.viewModel = viewModel
            self.viewController = tabBar
            
            window?.rootViewController = tabBar
            coordinator.requestUserCredentials(.home)
        }
    }
    
    func showScreen(_ screen: Screen, _ tableViewState: HomeTableViewDataSource.State) {
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
            coordinator = TabBarCoordinator()
            
            tabBar.viewModel = viewModel
            coordinator.tableViewState.value = tableViewState
            coordinator.viewController = tabBar
            viewModel.coordinator = coordinator
            tabBar.viewModel = viewModel
            self.viewController = tabBar
            
            window?.rootViewController = tabBar
            
            if tableViewState == .all {
                coordinator.requestUserCredentials(.home)
            } else if tableViewState == .series {
                coordinator.requestUserCredentials(.tvShows)
            } else if tableViewState == .films {
                coordinator.requestUserCredentials(.movies)
            } else {}
        }
    }
}

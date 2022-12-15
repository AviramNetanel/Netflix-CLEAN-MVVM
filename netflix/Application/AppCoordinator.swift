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
            if coordinator == nil {
                coordinator = TabBarCoordinator()
            }

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
            if coordinator == nil {
                coordinator = TabBarCoordinator()
            }
            
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
    
    func replaceRootCoordinator() {
        AsyncImageFetcher.shared.cache.removeAllObjects()
        
        let tabBar = Application.current.coordinator.window?.rootViewController as! TabBarController
        let homeNavigation = coordinator.viewController?.viewControllers?.first! as! UINavigationController
        let homeViewController = homeNavigation.viewControllers.first! as! HomeViewController
        let navigationView = homeViewController.navigationView!
        
        homeViewController.removeFromParent()
        
        coordinator.viewController = nil
        tabBar.viewModel.coordinator = nil
        Application.current.coordinator.viewController = nil
        
        if navigationView.viewModel.state.value == .home {
            Application.current.coordinator.showScreen(.tabBar, .all)
        } else if navigationView.viewModel.state.value == .tvShows {
            Application.current.coordinator.showScreen(.tabBar, .series)
        } else if navigationView.viewModel.state.value == .movies {
            Application.current.coordinator.showScreen(.tabBar, .films)
        } else {}
    }
}

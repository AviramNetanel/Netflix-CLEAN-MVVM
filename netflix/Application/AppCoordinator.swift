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
        let homeViewController = homeNavigation.viewControllers.first! as? HomeViewController
        let navigationView = homeViewController?.navigationView!
        
        homeViewController?.dataSource?.displayCell?.displayView?.panelView?.leadingItemView?.configuration?.tapRecognizer = nil
        homeViewController?.dataSource?.displayCell?.displayView?.panelView?.leadingItemView?.configuration?.longPressRecognizer = nil
        homeViewController?.dataSource?.displayCell?.displayView?.panelView?.leadingItemView?.configuration?.view = nil
        homeViewController?.dataSource?.displayCell?.displayView?.panelView?.leadingItemView?.configuration = nil
        homeViewController?.dataSource?.displayCell?.displayView?.panelView?.leadingItemView?.viewModel = nil
        homeViewController?.dataSource?.displayCell?.displayView?.panelView?.leadingItemView?.removeFromSuperview()
        homeViewController?.dataSource?.displayCell?.displayView?.panelView?.leadingItemView = nil
        homeViewController?.dataSource?.displayCell?.displayView?.panelView?.trailingItemView?.configuration.longPressRecognizer = nil
        homeViewController?.dataSource?.displayCell?.displayView?.panelView?.trailingItemView?.configuration.tapRecognizer = nil
        homeViewController?.dataSource?.displayCell?.displayView?.panelView?.trailingItemView?.configuration?.view = nil
        homeViewController?.dataSource?.displayCell?.displayView?.panelView?.trailingItemView?.configuration = nil
        homeViewController?.dataSource?.displayCell?.displayView?.panelView?.trailingItemView?.viewModel = nil
        homeViewController?.dataSource?.displayCell?.displayView?.panelView?.trailingItemView?.removeFromSuperview()
        homeViewController?.dataSource?.displayCell?.displayView?.panelView?.trailingItemView = nil
        homeViewController?.dataSource?.displayCell?.displayView?.panelView?.viewModel = nil
        homeViewController?.dataSource?.displayCell?.displayView?.panelView?.removeFromSuperview()
        homeViewController?.dataSource?.displayCell?.displayView?.panelView = nil
        homeViewController?.dataSource?.displayCell?.displayView?.configuration = nil
        homeViewController?.dataSource?.displayCell?.displayView?.viewModel = nil
        homeViewController?.dataSource?.displayCell?.displayView?.removeFromSuperview()
        homeViewController?.dataSource?.displayCell?.displayView = nil
        homeViewController?.dataSource?.displayCell = nil

        homeViewController?.dataSource?.tableView.removeFromSuperview()
        homeViewController?.dataSource?.tableView.delegate = nil
        homeViewController?.dataSource?.tableView.dataSource = nil
        homeViewController?.dataSource?.tableView = nil
        homeViewController?.dataSource = nil
        homeViewController?.tableView?.delegate = nil
        homeViewController?.tableView?.dataSource = nil
        homeViewController?.tableView?.removeFromSuperview()
        homeViewController?.tableView = nil

        homeViewController?.navigationView?.navigationOverlayView?.tableView.removeFromSuperview()
        homeViewController?.navigationView?.navigationOverlayView?.removeFromSuperview()
        homeViewController?.navigationView?.navigationOverlayView = nil
        homeViewController?.navigationView?.removeFromSuperview()
        homeViewController?.navigationView = nil

        homeViewController?.browseOverlayView?.removeFromSuperview()
        homeViewController?.browseOverlayView = nil

        homeViewController?.viewModel?.myList?.removeObservers()
        homeViewController?.viewModel?.coordinator = nil
        homeViewController?.viewModel?.mediaTask = nil
        homeViewController?.viewModel?.sectionsTask = nil
        homeViewController?.viewModel?.tableViewState = nil
        homeViewController?.viewModel?.myList = nil
        homeViewController?.viewModel = nil

        homeViewController?.removeObservers()
        homeViewController?.removeFromParent()
        
        coordinator.viewController = nil
        tabBar.viewModel.coordinator = nil
        Application.current.coordinator.viewController = nil
        
        if navigationView?.viewModel.state.value == .home {
            Application.current.coordinator.showScreen(.tabBar, .all)
        } else if navigationView?.viewModel.state.value == .tvShows {
            Application.current.coordinator.showScreen(.tabBar, .series)
        } else if navigationView?.viewModel.state.value == .movies {
            Application.current.coordinator.showScreen(.tabBar, .films)
        } else {}
    }
}

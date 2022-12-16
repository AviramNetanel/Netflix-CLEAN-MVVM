//
//  RootCoordinator.swift
//  netflix
//
//  Created by Zach Bazov on 05/12/2022.
//

import UIKit

final class RootCoordinator: Coordinate {
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
    private(set) var tabCoordinator: TabBarCoordinator!
    
    func showScreen(_ screen: Screen) {
        if case .auth = screen {
            presentAuthScreen()
            return
        }
        
        presentTabBarScreen(.all)
    }
    
    private func presentAuthScreen() {
        let coordinator = AuthCoordinator()
        let viewModel = AuthViewModel()
        let controller = AuthController()
        
        coordinator.viewController = controller
        viewModel.coordinator = coordinator
        controller.viewModel = viewModel
        
        controller.setNavigationBarHidden(false, animated: false)
        
        window?.rootViewController = controller
        coordinator.showScreen(.intro)
    }
    
    private func presentTabBarScreen(_ tableViewState: HomeTableViewDataSource.State) {
        let tabBar = TabBarController()
        let viewModel = TabBarViewModel()
        if tabCoordinator == nil {
            tabCoordinator = TabBarCoordinator()
        }
        
        tabBar.viewModel = viewModel
        tabCoordinator.viewController?.viewModel.tableViewState.value = tableViewState
        tabCoordinator.viewController = tabBar
        viewModel.coordinator = tabCoordinator
        tabBar.viewModel = viewModel
        self.viewController = tabBar
        
        window?.rootViewController = tabBar
        
        if tableViewState == .all {
            tabCoordinator.requestUserCredentials(.home)
        } else if tableViewState == .series {
            tabCoordinator.requestUserCredentials(.tvShows)
        } else if tableViewState == .films {
            tabCoordinator.requestUserCredentials(.movies)
        } else {}
    }
    
    private func tabBar(with tableViewState: HomeTableViewDataSource.State) {
        presentTabBarScreen(tableViewState)
    }
    
    func replaceRootCoordinator() {
        AsyncImageFetcher.shared.cache.removeAllObjects()
        
        let tabBar = Application.current.rootCoordinator.tabCoordinator.viewController
        let homeNavigation = tabCoordinator.viewController?.viewControllers?.first! as! UINavigationController
        let homeViewController = homeNavigation.viewControllers.first! as? HomeViewController
        let navigationView = homeViewController?.navigationView!
        
        homeViewController?.dataSource?.terminate()
        tabBar?.viewModel.coordinator?.terminateHomeViewController()
        
        tabCoordinator.viewController = nil
        tabBar?.viewModel.coordinator = nil
        viewController = nil
        
        if navigationView?.viewModel.state.value == .home {
            self.tabBar(with: .all)
        } else if navigationView?.viewModel.state.value == .tvShows {
            self.tabBar(with: .series)
        } else if navigationView?.viewModel.state.value == .movies {
            self.tabBar(with: .films)
        } else {}
    }
}

//
//  TabBarCoordinator.swift
//  netflix
//
//  Created by Zach Bazov on 05/12/2022.
//

import UIKit

final class TabBarCoordinator: Coordinate {
    enum Screen {
        case home
    }
    
    weak var viewController: TabBarController?
    
    func showScreen(_ screen: Screen) {
        switch screen {
        case .home:
            let home = homeNavigation(.home)
            viewController?.viewControllers = [home]
        }
    }
    
    private func createHomeNavigationController(with state: NavigationView.State? = nil) {
        let home = homeNavigation(state)
        viewController?.viewControllers = [home]
    }
    
    private func homeNavigation(_ state: NavigationView.State?) -> UINavigationController {
        let coordinator = HomeViewCoordinator()
        let viewModel = HomeViewModel()
        let controller = HomeViewController()
        
        if state == .tvShows {
            viewController?.viewModel.tableViewState.value = .series
        } else if state == .movies {
            viewController?.viewModel.tableViewState.value = .films
        } else if state == .home {
            viewController?.viewModel.tableViewState.value = .all
        } else {}
        
        viewModel.tableViewState = viewController?.viewModel.tableViewState.value
        controller.viewModel = viewModel
        controller.viewModel.tableViewState = viewController?.viewModel.tableViewState.value
        controller.viewModel.coordinator = coordinator
        controller.viewModel.coordinator?.viewController = controller
        coordinator.viewController = controller
        coordinator.viewController?.viewModel = viewModel
        
        let navigationController = UINavigationController(rootViewController: controller)
        setupNavigation(navigationController)
        
        return navigationController
    }
    
    private func setupNavigation(_ controller: UINavigationController) {
        controller.tabBarItem = UITabBarItem(title: "Home",
                                             image: UIImage(systemName: "house.fill")?.whiteRendering(),
                                             tag: 0)
        controller.tabBarItem.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0, weight: .bold)], for: .normal)
        controller.setNavigationBarHidden(true, animated: false)
    }
    
    func requestUserCredentials(_ state: NavigationView.State?) {
        let viewModel = AuthViewModel()
        viewModel.cachedAuthorizationSession { [weak self] in
            self?.createHomeNavigationController(with: state)
        }
    }
    
    func terminateHomeViewController() {
        let tabBar = Application.current.rootCoordinator.window?.rootViewController as! TabBarController
        let homeNavigation = tabBar.viewControllers?.first! as! UINavigationController
        let homeViewController = homeNavigation.viewControllers.first! as? HomeViewController
        
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
    }
}

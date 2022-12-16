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
    private(set) var tableViewState: Observable<HomeTableViewDataSource.State> = Observable(.all)
    var lastSelection: NavigationView.State!
    
    func showScreen(_ screen: Screen, _ state: NavigationView.State? = nil) {
        switch screen {
        case .home:
            let home = homeNavigation(state)
            viewController?.viewControllers = [home]
        }
    }
    
    func showScreen(_ screen: Screen) {
        switch screen {
        case .home:
            let home = homeNavigation(.home)
            viewController?.viewControllers = [home]
        }
    }
    
    func requestUserCredentials(_ state: NavigationView.State?) {
        let viewModel = AuthViewModel()
        viewModel.cachedAuthorizationSession { [weak self] in self?.showScreen(.home, state) }
    }
    
    private func homeNavigation(_ state: NavigationView.State?) -> UINavigationController {
        let coordinator = HomeViewCoordinator()
        let viewModel = HomeViewModel()
        let controller = HomeViewController()
        
        if state == .tvShows {
            tableViewState.value = .series
        } else if state == .movies {
            tableViewState.value = .films
        } else if state == .home {
            tableViewState.value = .all
        } else {}
        
        viewModel.tableViewState = tableViewState.value
        controller.viewModel = viewModel
        controller.viewModel.tableViewState = tableViewState.value
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
    
    func terminate() {
        viewController?.viewModel.coordinator = nil
    }
}

/*
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
     private(set) var tableViewState: Observable<HomeTableViewDataSource.State> = Observable(.all)
     var lastSelection: NavigationView.State!
     
     func showScreen(_ screen: Screen, _ state: NavigationView.State? = nil) {
         switch screen {
         case .home:
             let home = homeNavigation(state)
             viewController?.viewControllers = [home]
         }
     }
     
     func showScreen(_ screen: Screen) {
         switch screen {
         case .home:
             let home = homeNavigation(.home)
             viewController?.viewControllers = [home]
         }
     }
     
     func requestUserCredentials(_ state: NavigationView.State?) {
         let viewModel = AuthViewModel()
         viewModel.cachedAuthorizationSession { [weak self] in self?.showScreen(.home, state) }
     }
     
     private func homeNavigation(_ state: NavigationView.State?) -> UINavigationController {
         let coordinator = HomeViewCoordinator()
         let viewModel = HomeViewModel()
         let controller = HomeViewController()
         
         if state == .tvShows {
             tableViewState.value = .series
         } else if state == .movies {
             tableViewState.value = .films
         } else if state == .home {
             tableViewState.value = .all
         } else {}
         
         viewModel.tableViewState = tableViewState.value
         controller.viewModel = viewModel
         controller.viewModel.tableViewState = tableViewState.value
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
     
     func terminate() {
         viewController?.viewModel.coordinator = nil
     }
 }

 */







/*
 final class TabBarCoordinator: Coordinate {
     enum Screen {
         case home
     }
     
     weak var viewController: TabBarController?
     private(set) var tableViewState: Observable<HomeTableViewDataSource.State> = Observable(.all)
     var lastSelection: NavigationView.State!
     
     func showScreen(_ screen: Screen, _ state: NavigationView.State? = nil) {
         switch screen {
         case .home:
             let home = homeNavigation(state)
             viewController?.viewControllers = [home]
         }
     }
     
     func showScreen(_ screen: Screen) {
         switch screen {
         case .home:
             let home = homeNavigation(.home)
             viewController?.viewControllers = [home]
         }
     }
     
     func requestUserCredentials(_ state: NavigationView.State?) {
         let viewModel = AuthViewModel()
         viewModel.cachedAuthorizationSession { [weak self] in
             self?.showScreen(.home, state)
         }
     }
     
     private func homeNavigation(_ state: NavigationView.State?) -> UINavigationController {
         let coordinator = HomeViewCoordinator()
         let viewModel = HomeViewModel()
         let controller = HomeViewController()
         
         if state == .tvShows {
             tableViewState.value = .series
         } else if state == .movies {
             tableViewState.value = .films
         } else if state == .home {
             tableViewState.value = .all
         } else {}
         
         viewModel.tableViewState = tableViewState.value
         controller.viewModel = viewModel
         controller.viewModel.tableViewState = tableViewState.value
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
     
     func terminate() {
         viewController?.viewModel.coordinator = nil
     }
 }
 */

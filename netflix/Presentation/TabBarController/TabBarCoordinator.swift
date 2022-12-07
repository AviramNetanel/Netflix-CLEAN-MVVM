//
//  TabBarCoordinator.swift
//  netflix
//
//  Created by Zach Bazov on 05/12/2022.
//

import UIKit

// MARK: - TabBarCoordinator class

final class TabBarCoordinator: Coordinate {
    
    enum Screen {
        case home
    }
    
    weak var viewController: TabBarController?
    
    func showScreen(_ screen: Screen) {
        switch screen {
        case .home:
            let home = homeNavigation()
            viewController?.viewControllers = [home]
        }
    }
    
    func requestUserCredentials() {
        let viewModel = AuthViewModel()
        viewModel.cachedAuthorizationSession { [weak self] in self?.showScreen(.home) }
    }
    
    private func homeNavigation() -> UINavigationController {
        let authService = Application.current.authService
        let dataTransferService = Application.current.dataTransferService
        
        let controller = HomeViewController()
        let mediaResponseCache = Application.current.mediaResponseCache
        let sectionRepository = SectionRepository(dataTransferService: dataTransferService)
        let mediaRepository = MediaRepository(dataTransferService: dataTransferService, cache: mediaResponseCache)
        let listRepository = ListRepository(dataTransferService: dataTransferService)
        let useCase = HomeUseCase(sectionsRepository: sectionRepository, mediaRepository: mediaRepository, listRepository: listRepository)
        let coordinator = HomeViewCoordinator()
        let viewModel = HomeViewModel(authService: authService, useCase: useCase)
        
        controller.viewModel = viewModel
        controller.viewModel.coordinator = coordinator
        coordinator.viewController = controller
        
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
}

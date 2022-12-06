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
        case browse
    }
    
    weak var viewController: TabBarController?
    
    func showScreen(_ screen: Screen) {}
    
    func setupTabBar() {
        let browse = browseNavigation()
        viewController?.viewControllers = [browse]
    }
    
    private func browseNavigation() -> UINavigationController {
        let authService = Application.current.coordinator.authService
        let dataTransferService = Application.current.coordinator.dataTransferService
        let authResponseCache = AuthResponseStorage(authService: authService)
//
        let authRepository = AuthRepository(dataTransferService: dataTransferService, cache: authResponseCache)
        let authUseCase = AuthUseCase(authRepository: authRepository)
        let authViewModel = AuthViewModel(authUseCase: authUseCase)
        authViewModel.userDidAuthorize()
        
        let controller = HomeViewController()
        let mediaResponseCache = Application.current.coordinator.mediaResponseCache
        let sectionRepository = SectionRepository(dataTransferService: dataTransferService)
        let mediaRepository = MediaRepository(dataTransferService: dataTransferService, cache: mediaResponseCache)
        let listRepository = ListRepository(dataTransferService: dataTransferService)
        let useCase = HomeUseCase(sectionsRepository: sectionRepository, mediaRepository: mediaRepository, listRepository: listRepository)
        let coordinator = HomeViewCoordinator()
        coordinator.viewController = controller
        //let actions = HomeViewModelActions()
        let viewModel = HomeViewModel(authService: authService, useCase: useCase)
        controller.viewModel = viewModel
        controller.viewModel.coordinator = coordinator
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.tabBarItem = UITabBarItem(title: "Browse", image: UIImage(systemName: "house.fill")?.whiteRendering(), tag: 0)
        navigationController.tabBarItem.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0, weight: .bold)], for: .normal)
        navigationController.setNavigationBarHidden(true, animated: false)
        return navigationController
    }
}

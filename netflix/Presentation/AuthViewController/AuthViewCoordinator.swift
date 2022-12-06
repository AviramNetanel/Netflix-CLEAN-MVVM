//
//  AuthViewCoordinator.swift
//  netflix
//
//  Created by Zach Bazov on 05/12/2022.
//

import UIKit

// MARK: - AuthViewCoordinator class

final class AuthViewCoordinator: Coordinate {
    
    enum Screen {
        case intro
        case signIn
        case signUp
    }
    
    var viewController: AuthViewController?
    var navigationController: NavigationController!
    
    func showScreen(_ screen: Screen) {}
    
    func authNavigation() -> UINavigationController {
        let authService = Application.current.coordinator.authService
        let dataTransferService = Application.current.coordinator.dataTransferService
        let authResponseCache = AuthResponseStorage(authService: authService)
        let authRepository = AuthRepository(dataTransferService: dataTransferService, cache: authResponseCache)
        let useCase = AuthUseCase(authRepository: authRepository)
        let viewModel = AuthViewModel(authUseCase: useCase)
        let controller = AuthViewController()
        
        viewController = controller
        viewController?.viewModel = viewModel
        viewController?.viewModel.coordinator = self
        
        navigationController = NavigationController(rootViewController: controller)
        navigationController.setNavigationBarHidden(false, animated: false)
        return navigationController
    }
    
    @objc func presentSignInViewController() {
        let controller = SignInViewController()
        controller.viewModel = viewController?.viewModel
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func presentSignUpViewController() {
        let controller = SignUpViewController()
        controller.viewModel = viewController?.viewModel
        navigationController?.pushViewController(controller, animated: true)
    }
}

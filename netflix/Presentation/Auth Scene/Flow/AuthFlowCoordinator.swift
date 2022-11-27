//
//  AuthFlowCoordinator.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import UIKit

// MARK: - AuthFlowCoordinatorDependencies protocol

protocol AuthFlowCoordinatorDependencies {
    func createAuthUseCase() -> AuthUseCase
    func createAuthRepository() -> AuthRepository
    func createAuthViewModelActions() -> AuthViewModelActions
    func createAuthViewController() -> AuthViewController
    func createAuthViewModel() -> AuthViewModel
}

// MARK: - AuthFlowCoordinator class

final class AuthFlowCoordinator {
    
    private let appFlowDependencies: AppFlowCoordinatorDependencies
    private let dependencies: AuthFlowCoordinatorDependencies
    private weak var navigationController: UINavigationController?
    private weak var authViewController: AuthViewController?
    
    init(appFlowDependencies: AppFlowCoordinatorDependencies,
         navigationController: UINavigationController,
         dependencies: AuthFlowCoordinatorDependencies) {
        self.appFlowDependencies = appFlowDependencies
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
}

// MARK: - FlowCoordinatorInput implmenetation

extension AuthFlowCoordinator: FlowCoordinatorInput {
    
    func launch() {
        authViewController = dependencies.createAuthViewController()
    }
    
    func coordinate() {
        guard let authViewController = authViewController else { return }
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.pushViewController(authViewController, animated: false)
    }
    
    func sceneDidDisconnect() {}
}

// MARK: - AuthViewModelActions implementation

extension AuthFlowCoordinator {
    
    func presentSignInViewController() {
        authViewController?.performSegue(withIdentifier: String(describing: SignInViewController.self), sender: authViewController)
    }
    
    func presentSignUpViewController() {
        authViewController?.performSegue(withIdentifier: String(describing: SignUpViewController.self), sender: authViewController)
    }
    
    func presentHomeViewController() {
        appFlowDependencies.createHomeSceneFlow()
    }
}

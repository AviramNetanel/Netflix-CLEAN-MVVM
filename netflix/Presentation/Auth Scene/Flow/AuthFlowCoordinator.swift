//
//  AuthFlowCoordinator.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import UIKit

// MARK: - AuthFlowCoordinatorDependencies protocol

protocol AuthFlowCoordinatorDependencies {
    func createAuthViewController(actions: AuthViewModel.Actions) -> AuthViewController
}

// MARK: - AuthFlowCoordinator class

final class AuthFlowCoordinator {
    
    private let dependencies: AuthFlowCoordinatorDependencies
    private weak var appFlowCoordinator: AppFlowCoordinator?
    private weak var navigationController: UINavigationController?
    private weak var viewController: UIViewController?
    
    init(appFlowCoordinator: AppFlowCoordinator?,
         navigationController: UINavigationController,
         dependencies: AuthFlowCoordinatorDependencies) {
        self.appFlowCoordinator = appFlowCoordinator
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.create()
    }
}

// MARK: - FlowCoordinatorInput implmenetation

extension AuthFlowCoordinator: FlowCoordinatorInput {
    
    func create() {
        let actions = AuthViewModel.Actions(presentSignInViewController: presentSignInViewController,
                                            presentSignUpViewController: presentSignUpViewController,
                                            presentHomeViewController: presentHomeViewController)
        self.viewController = dependencies.createAuthViewController(actions: actions)
    }
    
    func coordinate() {
        guard let viewController = viewController else { return }
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.pushViewController(viewController, animated: false)
    }
    
    func sceneDidDisconnect() {}
}

// MARK: - AuthViewModelActions implementation

extension AuthFlowCoordinator {
    
    private func presentSignInViewController() {
        viewController?.performSegue(withIdentifier: String(describing: SignInViewController.self),
                                     sender: viewController)
    }
    
    private func presentSignUpViewController() {
        viewController?.performSegue(withIdentifier: String(describing: SignUpViewController.self),
                                     sender: viewController)
    }
    
    private func presentHomeViewController() {
        appFlowCoordinator?.createHomeSceneFlow()
    }
}

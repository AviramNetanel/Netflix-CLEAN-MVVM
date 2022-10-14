//
//  AuthFlowCoordinator.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import UIKit

// MARK: - AuthFlowCoordinatorDependencies protocol

protocol AuthFlowCoordinatorDependencies {
    func createAuthViewController(actions: AuthViewModelActions) -> AuthViewController
}

// MARK: - AuthFlowCoordinator class

final class AuthFlowCoordinator {
    
    private let dependencies: AuthFlowCoordinatorDependencies
    
    private weak var navigationController: UINavigationController?
    private weak var viewController: UIViewController?
    
    init(navigationController: UINavigationController,
         dependencies: AuthFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func coordinate() -> AuthFlowCoordinator {
        let actions = AuthViewModelActions(presentSignInViewController: presentSignInViewController,
                                           presentSignUpViewController: presentSignUpViewController,
                                           presentHomeViewController: presentHomeViewController)
        
        let viewController = dependencies.createAuthViewController(actions: actions)
        navigationController?.pushViewController(viewController, animated: false)
        
        self.viewController = viewController
        
        return self
    }
    
    private func presentSignInViewController() {
        viewController?.performSegue(withIdentifier: String(describing: SignInViewController.self),
                                     sender: viewController)
    }
    
    private func presentSignUpViewController() {
        viewController?.performSegue(withIdentifier: String(describing: SignUpViewController.self),
                                     sender: viewController)
    }
    
    private func presentHomeViewController() {
        viewController?.performSegue(withIdentifier: String(describing: HomeViewController.self),
                                     sender: viewController)
    }
}

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

// MARK: - FlowCoordinator class

final class AuthFlowCoordinator {
    
    private let dependencies: AuthFlowCoordinatorDependencies
    
    private weak var navigationController: UINavigationController?
    private weak var viewController: UIViewController?
    
    init(navigationController: UINavigationController, dependencies: AuthFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func coordinate() {
        let actions = AuthViewModelActions(showSignInViewController: showSignInViewController,
                                           showSignUpViewController: showSignUpViewController)
        let viewController = dependencies.createAuthViewController(actions: actions)
        navigationController?.pushViewController(viewController, animated: false)
        self.viewController = viewController
    }
    
    // MARK: Private
    
    private func showSignInViewController() {
        viewController?.performSegue(withIdentifier: "SegueSignInViewController", sender: viewController)
    }
    
    private func showSignUpViewController() {
        viewController?.performSegue(withIdentifier: "SegueSignUpViewController", sender: viewController)
    }
}

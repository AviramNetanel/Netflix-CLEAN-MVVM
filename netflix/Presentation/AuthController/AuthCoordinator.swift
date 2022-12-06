//
//  AuthCoordinator.swift
//  netflix
//
//  Created by Zach Bazov on 05/12/2022.
//

import UIKit

// MARK: - AuthCoordinator class

final class AuthCoordinator: Coordinate {
    
    enum Screen {
        case intro
        case signIn
        case signUp
    }
    
    var viewController: AuthController?
    
    func showScreen(_ screen: Screen) {
        switch screen {
        case .intro:
            presentLandpage()
        case .signIn:
            presentSignIn()
        case .signUp:
            presentSignUp()
        }
    }
    
    func presentLandpage() {
        let landpage = LandpageViewController()
        landpage.viewModel = viewController?.viewModel
        viewController?.pushViewController(landpage, animated: false)
    }
    
    @objc
    func presentSignIn() {
        let controller = SignInViewController()
        controller.viewModel = viewController?.viewModel
        viewController?.pushViewController(controller, animated: true)
    }
    
    @objc
    func presentSignUp() {
        let controller = SignUpViewController()
        controller.viewModel = viewController?.viewModel
        viewController?.pushViewController(controller, animated: true)
    }
}

//
//  AuthCoordinator.swift
//  netflix
//
//  Created by Zach Bazov on 05/12/2022.
//

import UIKit

final class AuthCoordinator: Coordinate {
    enum Screen {
        case intro
        case signIn
        case signUp
    }
    
    var viewController: AuthController?
    
    func showScreen(_ screen: Screen) {
        if case .intro = screen {
            presentLandpage()
        } else if case .signIn = screen {
            presentSignIn()
        } else {
            presentSignUp()
        }
    }
    
    private func presentLandpage() {
        let landpage = LandpageViewController()
        landpage.viewModel = viewController?.viewModel
        viewController?.pushViewController(landpage, animated: false)
    }
    
    @objc
    func presentSignIn() {
        let controller = SignInViewController()
        let viewModel = SignInViewModel(with: viewController!.viewModel)
        controller.viewModel = viewModel
        viewController?.pushViewController(controller, animated: true)
    }
    
    @objc
    func presentSignUp() {
        let controller = SignUpViewController()
        let viewModel = SignUpViewModel(with: viewController!.viewModel)
        controller.viewModel = viewModel
        viewController?.pushViewController(controller, animated: true)
    }
}

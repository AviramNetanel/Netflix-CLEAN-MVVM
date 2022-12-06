//
//  SignInViewController.swift
//  netflix
//
//  Created by Zach Bazov on 05/09/2022.
//

import UIKit

// MARK: - SignInViewController class

final class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    var viewModel: AuthViewModel!
    
    private var credentials: (String?, String?) {
        return (email: emailTextField.text, password: passwordTextField.text)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppAppearance.darkAppearance()
        setupSubviews()
    }
    
    private func setupSubviews() {
        setAttributes(for: [emailTextField,
                            passwordTextField])
        signInButton.setLayerBorder(.black, width: 1.5)
        setupTargets()
    }
    
    private func setupTargets() {
        signInButton.addTarget(self,
                               action: #selector(didSignIn),
                               for: .touchUpInside)
    }
    
    @objc
    private func didSignIn() {
        let userDTO = UserDTO(email: credentials.0, password: credentials.1)
        let requestDTO = AuthRequestDTO(user: userDTO)
        print("didSignIn")
        viewModel.signIn(request: requestDTO.toDomain()) { result in
            if case let .success(responseDTO) = result {
                Application.current.coordinator.authService.user = responseDTO.data
                Application.current.coordinator.authService.user.token = responseDTO.token
                Application.current.coordinator.showScreen(.tabBar)
                print("didSignIn Completion", Application.current.coordinator.authService.user)
            }
            if case let .failure(error) = result { print(error) }
        }
    }
}

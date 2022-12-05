//
//  SignUpViewController.swift
//  netflix
//
//  Created by Zach Bazov on 05/09/2022.
//

import UIKit

// MARK: - SignUpViewController class

final class SignUpViewController: UIViewController {
    
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordConfirmTextField: UITextField!
    @IBOutlet private weak var signUpButton: UIButton!
    
    var viewModel: AuthViewModel!
    
    private var credentials: (String?, String?, String?, String?) {
        return (name: nameTextField.text,
                email: emailTextField.text,
                password: passwordTextField.text,
                passwordConfirm: passwordConfirmTextField.text)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppAppearance.darkAppearance()
        setupSubviews()
    }
    
    private func setupSubviews() {
        setAttributes(for: [nameTextField,
                            emailTextField,
                            passwordTextField,
                            passwordConfirmTextField])
        signUpButton.setLayerBorder(.black, width: 1.5)
        setupTargets()
    }
    
    private func setupTargets() {
        signUpButton.addTarget(self,
                               action: #selector(didSignUp),
                               for: .touchUpInside)
    }
    
    @objc
    private func didSignUp() {
        guard let viewModel = viewModel else { return }
        
        let userDTO = UserDTO(name: credentials.0,
                              email: credentials.1,
                              password: credentials.2,
                              passwordConfirm: credentials.3)
        let requestDTO = AuthRequestDTO(user: userDTO)
        
        viewModel.signUp(request: requestDTO.toDomain()) { [weak self] result in
            guard let self = self else { return }
            if case .success = result { asynchrony {  } }
            if case let .failure(error) = result { print(error) }
        }
    }
}

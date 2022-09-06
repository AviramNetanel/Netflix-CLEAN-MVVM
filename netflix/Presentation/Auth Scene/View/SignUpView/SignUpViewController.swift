//
//  SignUpViewController.swift
//  netflix
//
//  Created by Zach Bazov on 05/09/2022.
//

import UIKit

// MARK: - SignUpViewController class

final class SignUpViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
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
        
        setupViews()
    }
    
    // MARK: Private
    
    private func setupViews() {
        setAttributes(for: [nameTextField,
                            emailTextField,
                            passwordTextField,
                            passwordConfirmTextField])
        
        signUpButton.setLayerBorder(.black, width: 1.5)
        
        setActions()
    }
    
    private func setActions() {
        signUpButton.addTarget(self,
                               action: #selector(didSignUp),
                               for: .touchUpInside)
    }
    
    @objc
    private func didSignUp() {
        guard let viewModel = viewModel as? DefaultAuthViewModel else { return }
        
        let userDTO = UserDTO(name: credentials.0,
                              email: credentials.1,
                              password: credentials.2,
                              passwordConfirm: credentials.3)
        let requestDTO = AuthRequestDTO(user: userDTO)
        let authQuery = AuthQuery(user: requestDTO.user)
        
        viewModel.signUp(query: authQuery) { [weak self] result in
            if case .success = result {
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: String(describing: HomeViewController.self),
                                      sender: self)
                }
            } else {
                print("failure")
                // error resolve
            }
        }
    }
}

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
        return (email: emailTextField.text,
                password: passwordTextField.text)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppAppearance.darkAppearance()
        setupViews()
    }
    
    private func setupViews() {
        setAttributes(for: [emailTextField,
                            passwordTextField])
        signInButton.setLayerBorder(.black, width: 1.5)
        setActions()
    }
    
    private func setActions() {
        signInButton.addTarget(self,
                               action: #selector(didSignIn),
                               for: .touchUpInside)
    }
    
    @objc
    private func didSignIn() {
        let userDTO = UserDTO(email: credentials.0,
                              password: credentials.1)
        let requestDTO = AuthRequestDTO(user: userDTO)
        let authQuery = AuthQuery(user: requestDTO.user)
        
        viewModel.signIn(query: authQuery) { [weak self] result in
            if case .success = result {
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: String(describing: HomeViewController.self),
                                      sender: self)
                }
            } else {
                printIfDebug("failure")
            }
        }
    }
}

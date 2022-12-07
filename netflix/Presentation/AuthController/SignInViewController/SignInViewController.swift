//
//  SignInViewController.swift
//  netflix
//
//  Created by Zach Bazov on 05/09/2022.
//

import UIKit

final class SignInViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    var viewModel: SignInViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppAppearance.darkAppearance()
        setupSubviews()
    }
    
    private func setupSubviews() {
        setAttributes(for: [emailTextField, passwordTextField])
        signInButton.setLayerBorder(.black, width: 1.5)
        setupTargets()
        addNavigationItemTitleView()
    }
    
    private func setupTargets() {
        signInButton.addTarget(viewModel, action: #selector(viewModel?.signInButtonDidTap), for: .touchUpInside)
        emailTextField.addTarget(self, action: #selector(textFieldValueDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldValueDidChange), for: .editingChanged)
    }
    
    @objc
    func textFieldValueDidChange(_ textField: UITextField) {
        if emailTextField == textField {
            viewModel?.email = textField.text
            return
        }
        viewModel?.password = textField.text
    }
}

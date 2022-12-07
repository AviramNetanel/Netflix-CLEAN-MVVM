//
//  SignUpViewController.swift
//  netflix
//
//  Created by Zach Bazov on 05/09/2022.
//

import UIKit

final class SignUpViewController: UIViewController {
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordConfirmTextField: UITextField!
    @IBOutlet private weak var signUpButton: UIButton!
    
    var viewModel: SignUpViewModel?
    
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
        addNavigationItemTitleView()
    }
    
    private func setupTargets() {
        signUpButton.addTarget(viewModel, action: #selector(viewModel?.signUpButtonDidTap), for: .touchUpInside)
        nameTextField.addTarget(self, action: #selector(textFieldValueDidChange), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldValueDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldValueDidChange), for: .editingChanged)
        passwordConfirmTextField.addTarget(self, action: #selector(textFieldValueDidChange), for: .editingChanged)
    }
    
    @objc
    func textFieldValueDidChange(_ textField: UITextField) {
        if nameTextField == textField {
            viewModel?.name = textField.text
        } else if emailTextField == textField {
            viewModel?.email = textField.text
        } else if passwordTextField == textField {
            viewModel?.password = textField.text
        } else {
            viewModel?.passwordConfirm = textField.text
        }
    }
}

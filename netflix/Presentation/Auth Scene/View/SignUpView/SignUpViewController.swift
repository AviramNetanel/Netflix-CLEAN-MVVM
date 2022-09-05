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
    }
}

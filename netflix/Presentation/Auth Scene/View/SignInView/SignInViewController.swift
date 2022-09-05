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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppAppearance.darkAppearance()
        setupViews()
    }
    
    // MARK: Private
    
    private func setupViews() {
        setAttributes(for: [emailTextField, passwordTextField])
        signInButton.setLayerBorder(.black, width: 1.5)
    }
}

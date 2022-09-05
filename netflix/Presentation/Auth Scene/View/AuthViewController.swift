//
//  AuthViewController.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import UIKit

// MARK: - AuthViewController class

final class AuthViewController: UIViewController, StoryboardInstantiable {
    
    private var viewModel: AuthViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBehaviors()
    }
    
    static func create(with viewModel: AuthViewModel) -> AuthViewController {
        let view = AuthViewController.instantiateViewController()
        view.viewModel = viewModel
        return view
    }
    
    // MARK: Private
    
    private func setupBehaviors() {
        addBehaviors([BackButtonEmptyTitleNavigationBarBehavior(),
                      BlackStyleNavigationBarBehavior()])
    }
}

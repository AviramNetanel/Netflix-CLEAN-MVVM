//
//  AuthViewController.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import UIKit

// MARK: - AuthViewController class

final class AuthViewController: UIViewController, StoryboardInstantiable {
    
    @IBOutlet private weak var statusBarGradientView: UIView!
    @IBOutlet private weak var topGradientView: UIView!
    @IBOutlet private weak var bottomGradientView: UIView!
    @IBOutlet private weak var signInButton: UIBarButtonItem!
    @IBOutlet private weak var signUpButton: UIButton!
    
    private var viewModel: DefaultAuthViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBehaviors()
        setupViews()
        viewModel.viewDidLoad()
    }
    
    static func create(with viewModel: DefaultAuthViewModel) -> AuthViewController {
        let view = AuthViewController.instantiateViewController()
        view.viewModel = viewModel
        return view
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: SignInViewController.self),
           let destinationVC = segue.destination as? SignInViewController,
           let signInViewController = destinationVC as SignInViewController? {
            
            signInViewController.viewModel = viewModel
            
        } else if segue.identifier == String(describing: SignUpViewController.self),
                  let destinationVC = segue.destination as? SignUpViewController,
                  let signUpViewController = destinationVC as SignUpViewController? {
            
            signUpViewController.viewModel = viewModel
            
        } else { view.alpha = 0.0 }
    }
    
    private func setupBehaviors() {
        addBehaviors([BackButtonEmptyTitleNavigationBarBehavior(),
                      BlackStyleNavigationBarBehavior()])
    }
    
    private func setupViews() {
        setGradientLayers()
        setActions()
    }
    
    private func setGradientLayers() {
        statusBarGradientView.addGradientLayer(frame: statusBarGradientView.bounds,
                                               colors:
                                                [.black.withAlphaComponent(0.75),
                                                 .black.withAlphaComponent(0.5),
                                                 .clear],
                                               locations: [0.0, 0.5, 1.0])
        
        topGradientView.addGradientLayer(frame: topGradientView.bounds,
                                         colors:
                                            [.clear,
                                             .black.withAlphaComponent(0.75),
                                             .black.withAlphaComponent(0.9)],
                                         locations: [0.0, 0.5, 1.0])
        
        bottomGradientView.addGradientLayer(frame: bottomGradientView.bounds,
                                            colors:
                                                [.black.withAlphaComponent(0.9),
                                                 .black.withAlphaComponent(0.75),
                                                 .clear],
                                            locations: [0.0, 0.5, 1.0])
    }
    
    private func setActions() {
        guard let viewModel = viewModel else { return }
        
        signInButton.addTarget(viewModel,
                               action: #selector(viewModel.signInButtonDidTap))
        
        signUpButton.addTarget(viewModel,
                               action: #selector(viewModel.signUpButtonDidTap),
                               for: .touchUpInside)
    }
}

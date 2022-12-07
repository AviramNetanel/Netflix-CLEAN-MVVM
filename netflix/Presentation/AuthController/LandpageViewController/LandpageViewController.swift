//
//  LandpageViewController.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import UIKit

final class LandpageViewController: UIViewController {
    @IBOutlet private weak var statusBarGradientView: UIView!
    @IBOutlet private weak var topGradientView: UIView!
    @IBOutlet private weak var bottomGradientView: UIView!
    @IBOutlet private weak var signUpButton: UIButton!
    
    var viewModel: AuthViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBehaviors()
        setupSubviews()
    }
    
    private func setupBehaviors() {
        addBehaviors([BackButtonEmptyTitleNavigationBarBehavior(),
                      BlackStyleNavigationBarBehavior()])
    }
    
    private func setupSubviews() {
        setupNavigationBarButtonItem()
        setupGradientViews()
        setupTargets()
    }
    
    private func setupNavigationBarButtonItem() {
        let button = UIBarButtonItem(title: "Sign In",
                                     style: .plain,
                                     target: viewModel.coordinator,
                                     action: #selector(viewModel.coordinator!.presentSignIn))
        navigationItem.rightBarButtonItem = button
    }
    
    private func setupGradientViews() {
        statusBarGradientView.addGradientLayer(
            frame: statusBarGradientView.bounds,
            colors:
                [.black.withAlphaComponent(0.75),
                 .black.withAlphaComponent(0.5),
                 .clear],
            locations: [0.0, 0.5, 1.0])
        
        topGradientView.addGradientLayer(
            frame: topGradientView.bounds,
            colors:
                [.clear,
                 .black.withAlphaComponent(0.75),
                 .black.withAlphaComponent(0.9)],
            locations: [0.0, 0.5, 1.0])
        
        bottomGradientView.addGradientLayer(
            frame: bottomGradientView.bounds,
            colors:
                [.black.withAlphaComponent(0.9),
                 .black.withAlphaComponent(0.75),
                 .clear],
            locations: [0.0, 0.5, 1.0])
    }
    
    private func setupTargets() {
        signUpButton.addTarget(viewModel.coordinator,
                               action: #selector(viewModel.coordinator!.presentSignUp),
                               for: .touchUpInside)
    }
}

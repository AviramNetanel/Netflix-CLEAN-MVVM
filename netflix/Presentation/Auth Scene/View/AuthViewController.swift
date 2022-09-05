//
//  AuthViewController.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import UIKit

// MARK: - AuthViewController class

final class AuthViewController: UIViewController, StoryboardInstantiable {
    
    @IBOutlet weak var statusBarGradientView: UIView!
    @IBOutlet weak var topGradientView: UIView!
    @IBOutlet weak var bottomGradientView: UIView!
    
    private var viewModel: AuthViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBehaviors()
        setupViews()
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
    
    private func setupViews() {
        setGradientLayers()
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
}

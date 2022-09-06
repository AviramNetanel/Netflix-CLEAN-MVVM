//
//  HomeViewController.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import UIKit

// MARK: - HomeViewController class

final class HomeViewController: UIViewController {
    
    private var viewModel: HomeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBehaviors()
    }
    
    static func create(with viewModel: HomeViewModel) -> HomeViewController {
        let view = UIStoryboard(name: String(describing: HomeTabBarController.self),
                                bundle: .main)
            .instantiateViewController(withIdentifier: String(describing: HomeViewController.self)) as! HomeViewController
        view.viewModel = viewModel
        return view
    }
    
    // MARK: Private
    
    private func setupBehaviors() {
        addBehaviors([BackButtonEmptyTitleNavigationBarBehavior(),
                      BlackStyleNavigationBarBehavior()])
    }
}

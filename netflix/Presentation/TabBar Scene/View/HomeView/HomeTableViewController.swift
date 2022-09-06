//
//  HomeTableViewController.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import UIKit

// MARK: - HomeTableViewController class

final class HomeTableViewController: UITableViewController {
    
    private var viewModel: HomeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBehaviors()
    }
    
    static func create(with viewModel: HomeViewModel) -> HomeTableViewController {
        let view = UIStoryboard(name: String(describing: HomeTabBarController.self),
                                bundle: .main)
            .instantiateViewController(withIdentifier: String(describing: HomeTableViewController.self)) as! HomeTableViewController
        view.viewModel = viewModel
        return view
    }
    
    // MARK: Private
    
    private func setupBehaviors() {
        addBehaviors([BackButtonEmptyTitleNavigationBarBehavior(),
                      BlackStyleNavigationBarBehavior()])
    }
}

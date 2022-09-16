//
//  HomeFlowCoordinator.swift
//  netflix
//
//  Created by Zach Bazov on 06/09/2022.
//

import UIKit

// MARK: - HomeFlowCoordinatorDependencies protocol

protocol HomeFlowCoordinatorDependencies {
    func createHomeViewController(actions: HomeViewModelActions) -> HomeViewController
}

// MARK: - HomeFlowCoordinator class

final class HomeFlowCoordinator {
    
    private let dependencies: HomeFlowCoordinatorDependencies
    
    private(set) weak var navigationController: UINavigationController?
    weak var viewController: UIViewController?
    
    lazy var homeViewController: HomeViewController? = {
        let actions = HomeViewModelActions(presentMediaDetails: presentMediaDetails)
        let viewController = dependencies.createHomeViewController(actions: actions)
        return viewController
    }()
    
    init(navigationController: UINavigationController,
         dependencies: HomeFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func coordinate() {        
        self.viewController = homeViewController
    }
    
    private func presentMediaDetails(media: Media) {
        viewController?.performSegue(withIdentifier: String(describing: DetailViewController.self),
                                     sender: viewController)
    }
    
    func sceneDidDisconnect() {
        
        //appFlowCoordinator?.homeFlowCoordinator?.viewController = homeViewController
        let homeViewController = (viewController as? HomeViewController)
        let panelView = homeViewController?.dataSource?.displayCell?.displayView?.panelView
        homeViewController?.viewModel?.removeObservers()
        panelView?.removeObservers()
    }
}

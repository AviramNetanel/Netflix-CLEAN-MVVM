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
    func createHomeViewModel(actions: HomeViewModelActions) -> DefaultHomeViewModel
    
    func createDetailViewController() -> DetailViewController
    func createDetailViewModel() -> DefaultDetailViewModel
}

// MARK: - HomeFlowCoordinator class

final class HomeFlowCoordinator {
    
    private let dependencies: HomeFlowCoordinatorDependencies
    
    private weak var navigationController: UINavigationController?
    private(set) weak var viewController: UIViewController?
    
    init(navigationController: UINavigationController,
         dependencies: HomeFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func coordinate() -> HomeFlowCoordinator {
        let actions = HomeViewModelActions(//presentNavigationView: presentNavigationView,
                                           presentMediaDetails: presentMediaDetails)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        let viewController = dependencies.createHomeViewController(actions: actions)
        self.viewController = viewController
        
        return self
    }
    
    func presentMediaDetails(media: Media) {
        guard
            let homeViewController = viewController as? HomeViewController,
            let detailViewController = dependencies.createDetailViewController() as DetailViewController?
        else { return }
        detailViewController.modalTransitionStyle = .coverVertical
        detailViewController.modalPresentationStyle = .automatic
        detailViewController.viewModel.media = media
        homeViewController.present(detailViewController, animated: true)
//        homeViewController.performSegue(withIdentifier: String(describing: DetailViewController.self),
//                                        sender: viewController)
    }
    
    func sceneDidDisconnect() {
        guard
            let homeViewController = viewController as? HomeViewController,
            let panelView = homeViewController.dataSource?.displayCell?.displayView?.panelView,
            let navigationView = homeViewController.navigationView,
            let categoriesOverlayView = homeViewController.categoriesOverlayView
        else { return }
        homeViewController.removeObservers()
        panelView.removeObservers()
        navigationView.viewModel?.removeObservers()
        categoriesOverlayView.removeObservers()
    }
}

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
    func createHomeViewModel(actions: HomeViewModelActions) -> HomeViewModel
    
    func createDetailViewController() -> DetailViewController
    func createDetailViewModel() -> DetailViewModel
}

// MARK: - HomeFlowCoordinator class

final class HomeFlowCoordinator {
    
    private let dependencies: HomeFlowCoordinatorDependencies
    
    private weak var navigationController: UINavigationController?
    private(set) weak var viewController: UIViewController?
    
    weak var detailViewController: DetailViewController?
    
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
    
    func presentMediaDetails(section: Section, media: Media) {
        guard let homeViewController = viewController as? HomeViewController else { return }
        detailViewController = dependencies.createDetailViewController()
        detailViewController?.modalPresentationCapturesStatusBarAppearance = true
        detailViewController?.modalTransitionStyle = .coverVertical
        detailViewController?.modalPresentationStyle = .automatic
        detailViewController?.viewModel.section = section
        detailViewController?.viewModel.media = media
        detailViewController?.viewModel.state = homeViewController.viewModel.state.value
        homeViewController.present(detailViewController!, animated: true)
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

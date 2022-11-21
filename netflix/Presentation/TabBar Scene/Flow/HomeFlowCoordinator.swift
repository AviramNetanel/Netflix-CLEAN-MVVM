//
//  HomeFlowCoordinator.swift
//  netflix
//
//  Created by Zach Bazov on 06/09/2022.
//

import UIKit

// MARK: - HomeFlowDependencies protocol

protocol HomeFlowDependencies {
    func createHomeTabBarController(actions: HomeViewModelActions) -> HomeTabBarController
    func createHomeViewController(actions: HomeViewModelActions) -> HomeViewController
    func createHomeViewModel(actions: HomeViewModelActions) -> HomeViewModel
}

// MARK: - DetailFlowDependencies protocol

protocol DetailFlowDependencies {
    func createDetailUseCase() -> DetailUseCase
    func createDetailViewDependencies(section: Section,
                                      media: Media,
                                      with viewModel: HomeViewModel) -> DetailViewModel.Dependencies
    func createDetailViewController(dependencies: DetailViewModel.Dependencies) -> DetailViewController
    func createDetailViewModel(dependencies: DetailViewModel.Dependencies) -> DetailViewModel
}

// MARK: - HomeFlowCoordinatorDependencies typealias

typealias HomeFlowCoordinatorDependencies = HomeFlowDependencies & DetailFlowDependencies

// MARK: - HomeFlowCoordinator class

final class HomeFlowCoordinator {
    
    private let dependencies: HomeFlowCoordinatorDependencies
    private weak var navigationController: UINavigationController?
    private weak var homeTabBarController: HomeTabBarController?
    private weak var detailViewController: DetailViewController?
    
    init(navigationController: UINavigationController,
         dependencies: HomeFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.create()
    }
}

// MARK: - FlowCoordinatorInput implementation

extension HomeFlowCoordinator: FlowCoordinatorInput {
    
    func create() {
        let actions = HomeViewModelActions(presentMediaDetails: presentMediaDetails)
        homeTabBarController = dependencies.createHomeTabBarController(actions: actions)
    }
    
    func coordinate() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.pushViewController(homeTabBarController!, animated: true)
    }
    
    func sceneDidDisconnect() {
        if let detailViewController = detailViewController {
            detailViewController.removeObservers()
        }
        
        if let homeViewController = homeTabBarController?.homeViewController {
            homeViewController.unbindObservers()
            homeViewController.viewModel.myList.unbindObservers()
            
            if let panelView = homeViewController.dataSource?.displayCell?.displayView?.panelView {
                panelView.viewDidUnobserve()
            }
            if let navigationView = homeViewController.navigationView {
                navigationView.viewDidUnobserve()
            }
            if let categoriesOverlayView = homeViewController.categoriesOverlayView {
                categoriesOverlayView.viewDidUnobserve()
            }
        }
    }
}

// MARK: - HomeViewModelActions implementation

extension HomeFlowCoordinator {
    
    func presentMediaDetails(section: Section, media: Media) {
        guard let homeViewController = homeTabBarController?.homeViewController else { return }
        let detailViewDependencies = dependencies.createDetailViewDependencies(
            section: section,
            media: media,
            with: homeViewController.viewModel)
        detailViewController = dependencies.createDetailViewController(dependencies: detailViewDependencies)
        homeViewController.present(detailViewController!, animated: true)
    }
}

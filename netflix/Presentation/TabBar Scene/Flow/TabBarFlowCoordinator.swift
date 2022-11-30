//
//  TabBarFlowCoordinator.swift
//  netflix
//
//  Created by Zach Bazov on 06/09/2022.
//

import UIKit

// MARK: - HomeFlowDependencies protocol

protocol HomeFlowDependencies {
    func createHomeUseCase() -> HomeUseCase
    func createSectionsRepository() -> SectionRepository
    func createMediaRepository() -> MediaRepository
    func createSeasonsRepoistory() -> SeasonRepository
    func createMyListRepository() -> ListRepository
    func createHomeViewModelActions() -> HomeViewModelActions
    func createTabBarController() -> TabBarController
    func createHomeViewController() -> HomeViewController
    func createHomeViewModel(dependencies: HomeViewModel.Dependencies) -> HomeViewModel
    func createHomeViewModelDependencies() -> HomeViewModel.Dependencies
    func createHomeViewDIProvider(launchingViewController homeViewController: HomeViewController) -> HomeViewDIProvider
    func createHomeViewDIProviderDependencies(launchingViewController homeViewController: HomeViewController) -> HomeViewDIProvider.Dependencies
}

// MARK: - DetailFlowDependencies protocol

protocol DetailFlowDependencies {
    func createDetailUseCase() -> DetailUseCase
    func createDetailViewDependencies(section: Section,
                                      media: Media,
                                      with viewModel: HomeViewModel) -> DetailViewModel.Dependencies
    func createDetailViewController(dependencies: DetailViewModel.Dependencies) -> DetailViewController
    func createDetailViewModel(dependencies: DetailViewModel.Dependencies) -> DetailViewModel
    func createDetailViewDIProvider(
        launchingViewController detailViewController: DetailViewController) -> DetailViewDIProvider
    func createDetailViewDIProviderDependencies(
        launchingViewController detailViewController: DetailViewController) -> DetailViewDIProvider.Dependencies
}

// MARK: - TabBarFlowCoordinatorDependencies typealias

typealias TabBarFlowCoordinatorDependencies = HomeFlowDependencies & DetailFlowDependencies

// MARK: - TabBarFlowCoordinator class

final class TabBarFlowCoordinator {
    
    private let dependencies: TabBarFlowCoordinatorDependencies
    private weak var navigationController: UINavigationController?
    private(set) weak var homeTabBarController: TabBarController?
    private(set) weak var detailViewController: DetailViewController?
    
    init(navigationController: UINavigationController,
         dependencies: TabBarFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
}

// MARK: - FlowCoordinatorInput implementation

extension TabBarFlowCoordinator: FlowCoordinatorInput {
    
    func launch() {
        homeTabBarController = dependencies.createTabBarController()
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
            homeViewController.removeObservers()
            homeViewController.viewModel.myList?.removeObservers()
            
            if let panelView = homeViewController.dataSource?.displayCell?.displayView.panelView {
                panelView.removeObservers()
            }
            if let navigationView = homeViewController.navigationView {
                navigationView.removeObservers()
            }
            if let categoriesOverlayView = homeViewController.categoriesOverlayView {
                categoriesOverlayView.removeObservers()
            }
        }
    }
}

// MARK: - HomeViewModelActions implementation

extension TabBarFlowCoordinator {
    
    func presentMediaDetails(section: Section, media: Media) {
        guard let homeViewController = homeTabBarController?.homeViewController else { return }
        let detailViewDependencies = dependencies.createDetailViewDependencies(
            section: section,
            media: media,
            with: homeViewController.viewModel)
        detailViewController = dependencies.createDetailViewController(dependencies: detailViewDependencies)
        homeViewController.present(detailViewController!, animated: true)
    }
    
    func navigationViewDidAppear() {
        guard let homeViewController = homeTabBarController?.homeViewController else { return }
        homeViewController.navigationViewTopConstraint.constant = 0.0
        homeViewController.navigationView.alpha = 1.0
        homeViewController.view.animateUsingSpring(withDuration: 0.66, withDamping: 1.0, initialSpringVelocity: 1.0)
    }
}

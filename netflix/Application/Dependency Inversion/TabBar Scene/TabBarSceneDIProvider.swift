//
//  TabBarSceneDIProvider.swift
//  netflix
//
//  Created by Zach Bazov on 26/11/2022.
//

import Foundation

// MARK: - TabBarSceneDIProvider class

final class TabBarSceneDIProvider {
    
    private weak var appFlowCoordinator: AppFlowCoordinator!
    private weak var appSceneDIProvider: AppSceneDIProvider!
    
    init(appFlowCoordinator: AppFlowCoordinator) {
        self.appFlowCoordinator = appFlowCoordinator
        self.appSceneDIProvider = appFlowCoordinator.appSceneDIProvider
    }
}

// MARK: - HomeFlowCoordinatorDependencies implementation

extension TabBarSceneDIProvider: TabBarFlowCoordinatorDependencies {
    
    // MARK: UseCases (Domain)
    
    func createHomeUseCase() -> HomeUseCase {
        return HomeUseCase(sectionsRepository: createSectionsRepository(),
                           mediaRepository: createMediaRepository(),
                           listRepository: createMyListRepository())
    }
    
    func createDetailUseCase() -> DetailUseCase {
        return DetailUseCase(seasonsRepository: createSeasonsRepoistory())
    }
    
    // MARK: Repositories (Data)
    
    func createSectionsRepository() -> SectionRepository {
        return SectionRepository(dataTransferService: appSceneDIProvider.dataTransferService)
    }
    
    func createMediaRepository() -> MediaRepository {
        return MediaRepository(dataTransferService: appSceneDIProvider.dataTransferService,
                               cache: appSceneDIProvider.mediaResponseCache)
    }
    
    func createSeasonsRepoistory() -> SeasonRepository {
        return SeasonRepository(dataTransferService: appSceneDIProvider.dataTransferService)
    }
    
    func createMyListRepository() -> ListRepository {
        return ListRepository(dataTransferService: appSceneDIProvider.dataTransferService)
    }
    
    // MARK: HomeView (Presentation)
    
    func createTabBarController() -> TabBarController {
        return .create(with: [createHomeViewController()])
    }
    
    func createHomeViewController() -> HomeViewController {
        return .create(with: createHomeViewModel(dependencies: createHomeViewModelDependencies()))
    }
    
    func createHomeViewModel(dependencies: HomeViewModel.Dependencies) -> HomeViewModel {
        return HomeViewModel(dependencies: dependencies)
    }
    
    func createHomeViewModelDependencies() -> HomeViewModel.Dependencies {
        return HomeViewModel.Dependencies(authService: appSceneDIProvider.authService,
                                          homeUseCase: createHomeUseCase(),
                                          actions: createHomeViewModelActions())
    }
    
    func createHomeViewModelActions() -> HomeViewModelActions {
        return HomeViewModelActions(homeFlowCoordinator: appFlowCoordinator.homeFlowCoordinator)
    }
    
    /// `HomeViewDIProvider` is an encapsulation for this `TabBarSceneDIProvider` class.
    /// It's holding all the relevant view dependencies for `TabBar Scene > HomeView` presentation group,
    /// In-order to instantiate `HomeViewController` subviews.
    /// - Parameter homeViewController: Launching view controller that holds all the the relevant presentation objects.
    /// - Returns: `HomeViewDIProvider` dependency inversion object.
    func createHomeViewDIProvider(
        launchingViewController homeViewController: HomeViewController) -> HomeViewDIProvider {
            return HomeViewDIProvider(dependencies: createHomeViewDIProviderDependencies(launchingViewController: homeViewController))
        }
    
    func createHomeViewDIProviderDependencies(
        launchingViewController homeViewController: HomeViewController) -> HomeViewDIProvider.Dependencies {
            return HomeViewDIProvider.Dependencies(homeViewController: homeViewController,
                                                   homeViewModel: homeViewController.viewModel,
                                                   tableView: homeViewController.tableView)
        }
    
    // MARK: DetailView (Presentation)
    
    func createDetailViewController(dependencies: DetailViewModel.Dependencies) -> DetailViewController {
        return .create(with: createDetailViewModel(dependencies: dependencies))
    }
    
    func createDetailViewModel(dependencies: DetailViewModel.Dependencies) -> DetailViewModel {
        return DetailViewModel(dependencies: dependencies)
    }
    
    func createDetailViewDependencies(section: Section,
                                      media: Media,
                                      with viewModel: HomeViewModel) -> DetailViewModel.Dependencies {
        return DetailViewModel.Dependencies(detailUseCase: createDetailUseCase(),
                                            section: section,
                                            media: media,
                                            viewModel: viewModel)
    }
    
    func createDetailViewDIProvider(
        launchingViewController detailViewController: DetailViewController) -> DetailViewDIProvider {
            return DetailViewDIProvider(
                dependencies: createDetailViewDIProviderDependencies(launchingViewController: detailViewController))
        }
    
    func createDetailViewDIProviderDependencies(
        launchingViewController detailViewController: DetailViewController) -> DetailViewDIProvider.Dependencies {
            return DetailViewDIProvider.Dependencies(detailViewController: detailViewController,
                                                     detailViewModel: detailViewController.viewModel,
                                                     tableView: detailViewController.tableView)
        }
}

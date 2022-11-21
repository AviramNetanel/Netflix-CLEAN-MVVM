//
//  SceneDependencies.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import UIKit

// MARK: - SceneDependable protocol

protocol SceneDependable {
    func createAuthFlowCoordinator(appFlowCoordinator: AppFlowCoordinator,
                                   navigationController: UINavigationController) -> AuthFlowCoordinator
    func createHomeFlowCoordinator(navigationController: UINavigationController) -> HomeFlowCoordinator
}

// MARK: - SceneDependencies class

final class SceneDependencies {
    
    struct Dependencies {
        let dataTransferService: DataTransferService
        let authService: AuthService
    }
    
    private let dependencies: Dependencies
    lazy var authResponseCache: AuthResponseStorage = AuthResponseStorage(authService: dependencies.authService)
    lazy var mediaResponseCache: MediaResponseStorage = MediaResponseStorage()
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: UseCases
    
    func createAuthUseCase() -> AuthUseCase {
        return AuthUseCase(authRepository: createAuthRepository())
    }
    
    func createHomeUseCase() -> HomeUseCase {
        return HomeUseCase(sectionsRepository: createSectionsRepository(),
                           mediaRepository: createMediaRepository(),
                           listRepository: createMyListRepository())
    }
    
    func createDetailUseCase() -> DetailUseCase {
        return DetailUseCase(seasonsRepository: createSeasonsRepoistory())
    }
    
    // MARK: Repositories
    
    func createAuthRepository() -> AuthRepository {
        return AuthRepository(dataTransferService: dependencies.dataTransferService,
                              cache: authResponseCache)
    }
    
    func createSectionsRepository() -> SectionRepository {
        return SectionRepository(dataTransferService: dependencies.dataTransferService)
    }
    
    func createMediaRepository() -> MediaRepository {
        return MediaRepository(dataTransferService: dependencies.dataTransferService,
                               cache: mediaResponseCache)
    }
    
    func createSeasonsRepoistory() -> SeasonRepository {
        return SeasonRepository(dataTransferService: dependencies.dataTransferService)
    }
    
    func createMyListRepository() -> ListRepository {
        return ListRepository(dataTransferService: dependencies.dataTransferService)
    }
}

// MARK: - SceneDependable implementation

extension SceneDependencies: SceneDependable {
    
    func createAuthFlowCoordinator(appFlowCoordinator: AppFlowCoordinator,
                                   navigationController: UINavigationController) -> AuthFlowCoordinator {
        return AuthFlowCoordinator(appFlowCoordinator: appFlowCoordinator,
                                   navigationController: navigationController,
                                   dependencies: self)
    }
    
    func createHomeFlowCoordinator(navigationController: UINavigationController) -> HomeFlowCoordinator {
        return HomeFlowCoordinator(navigationController: navigationController,
                                   dependencies: self)
    }
}

// MARK: - AuthFlowCoordinatorDependencies implementation

extension SceneDependencies: AuthFlowCoordinatorDependencies {
    
    func createAuthViewController(actions: AuthViewModel.Actions) -> AuthViewController {
        return .create(with: createAuthViewModel(actions: actions))
    }
    
    func createAuthViewModel(actions: AuthViewModel.Actions) -> AuthViewModel {
        return .create(authUseCase: createAuthUseCase(), actions: actions)
    }
}

// MARK: - HomeFlowCoordinatorDependencies implementation

extension SceneDependencies: HomeFlowCoordinatorDependencies {
    
    // MARK: HomeView
    
    func createHomeTabBarController(actions: HomeViewModelActions) -> HomeTabBarController {
        return .create(with: createHomeViewController(actions: actions))
    }
    
    func createHomeViewController(actions: HomeViewModelActions) -> HomeViewController {
        return .create(with: createHomeViewModel(actions: actions))
    }
    
    func createHomeViewModel(actions: HomeViewModelActions) -> HomeViewModel {
        return .create(authService: dependencies.authService,
                       homeUseCase: createHomeUseCase(),
                       actions: actions)
    }
    
    // MARK: DetailView
    
    func createDetailViewDependencies(section: Section,
                                      media: Media,
                                      with viewModel: HomeViewModel) -> DetailViewModel.Dependencies {
        return DetailViewModel.Dependencies(detailUseCase: createDetailUseCase(),
                                            section: section,
                                            media: media,
                                            viewModel: viewModel)
    }
    
    func createDetailViewController(dependencies: DetailViewModel.Dependencies) -> DetailViewController {
        return .create(with: createDetailViewModel(dependencies: dependencies))
    }
    
    func createDetailViewModel(dependencies: DetailViewModel.Dependencies) -> DetailViewModel {
        return .create(dependencies: dependencies)
    }
}

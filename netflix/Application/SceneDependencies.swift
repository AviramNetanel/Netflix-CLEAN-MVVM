//
//  SceneDependencies.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import UIKit

// MARK: - SceneDependable protocol

protocol SceneDependable {
    func createAuthFlowCoordinator(navigationController: UINavigationController) -> AuthFlowCoordinator
    func createHomeFlowCoordinator(navigationController: UINavigationController) -> HomeFlowCoordinator
}

// MARK: - SceneDependencies class

final class SceneDependencies {
    
    struct Dependencies {
        let dataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies
    
    lazy var authResponseCache: AuthResponseStorage = AuthResponseStorage()
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: UseCases
    
    func createAuthUseCase() -> AuthUseCase {
        return AuthUseCase(authRepository: createAuthRepository())
    }
    
    func createHomeUseCase() -> HomeUseCase {
        return HomeUseCase(sectionsRepository: createSectionsRepository(),
                           mediaRepository: createMediaRepository())
    }
    
    func createDetailUseCase() -> DetailUseCase {
        return DetailUseCase(seasonsRepository: createSeasonsRepoistory())
    }
    
    // MARK: Repositories
    
    func createAuthRepository() -> AuthRepository {
        return AuthRepository(dataTransferService: dependencies.dataTransferService,
                              cache: authResponseCache)
    }
    
    func createSectionsRepository() -> SectionsRepository {
        return SectionsRepository(dataTransferService: dependencies.dataTransferService)
    }
    
    func createMediaRepository() -> MediaRepository {
        return MediaRepository(dataTransferService: dependencies.dataTransferService)
    }
    
    func createSeasonsRepoistory() -> SeasonsRepository {
        return SeasonsRepository(dataTransferService: dependencies.dataTransferService)
    }
    
    // MARK: - Scenes
    
    // MARK: AuthScene
    
    func createAuthViewController(actions: AuthViewModelActions) -> AuthViewController {
        return AuthViewController.create(with: createAuthViewModel(actions: actions))
    }
    
    func createAuthViewModel(actions: AuthViewModelActions) -> AuthViewModel {
        return AuthViewModel(authUseCase: createAuthUseCase(),
                             actions: actions)
    }
    
    // MARK: HomeView
    
    func createHomeViewController(actions: HomeViewModelActions) -> HomeViewController {
        return HomeViewController.create(with: createHomeViewModel(actions: actions))
    }
    
    func createHomeViewModel(actions: HomeViewModelActions) -> HomeViewModel {
        return HomeViewModel(homeUseCase: createHomeUseCase(),
                             actions: actions)
    }
    
    // MARK: DetailView
    
    func createDetailViewController() -> DetailViewController {
        return DetailViewController.create(with: createDetailViewModel())
    }
    
    func createDetailViewModel() -> DetailViewModel {
        return DetailViewModel(detailUseCase: createDetailUseCase())
    }
}

// MARK: - SceneDependable implementation

extension SceneDependencies: SceneDependable {
    
    func createAuthFlowCoordinator(navigationController: UINavigationController) -> AuthFlowCoordinator {
        return AuthFlowCoordinator(navigationController: navigationController,
                                   dependencies: self)
    }
    
    func createHomeFlowCoordinator(navigationController: UINavigationController) -> HomeFlowCoordinator {
        return HomeFlowCoordinator(navigationController: navigationController,
                                   dependencies: self)
    }
}

// MARK: - AuthFlowCoordinatorDependencies implementation

extension SceneDependencies: AuthFlowCoordinatorDependencies {}

// MARK: - HomeFlowCoordinatorDependencies implementation

extension SceneDependencies: HomeFlowCoordinatorDependencies {}

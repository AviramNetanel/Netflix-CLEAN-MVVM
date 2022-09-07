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
    
    lazy var authResponseCache: AuthResponseStorage = CoreDataAuthResponseStorage()
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: UseCases
    
    func createAuthUseCase() -> AuthUseCase {
        return DefaultAuthUseCase(authRepository: createAuthRepository())
    }
    
    func createHomeUseCase() -> HomeUseCase {
        return DefaultHomeUseCase(sectionsRepository: createSectionsRepository(),
                                  tvShowsRepository: createTVShowsRepository(),
                                  moviesRepository: createMoviesRepository())
    }
    
    // MARK: Repositories
    
    func createAuthRepository() -> AuthRepository {
        return DefaultAuthRepository(dataTransferService: dependencies.dataTransferService,
                                     cache: authResponseCache)
    }
    
    func createSectionsRepository() -> SectionsRepository {
        return DefaultSectionsRepository(dataTransferService: dependencies.dataTransferService)
    }
    
    func createTVShowsRepository() -> TVShowsRepository {
        return DefaultTVShowsRepository(dataTransferService: dependencies.dataTransferService)
    }
    
    func createMoviesRepository() -> MoviesRepository {
        return DefaultMoviesRepository(dataTransferService: dependencies.dataTransferService)
    }
    
    // MARK: Auth
    
    func createAuthViewController(actions: AuthViewModelActions) -> AuthViewController {
        return AuthViewController.create(with: createAuthViewModel(actions: actions))
    }
    
    func createAuthViewModel(actions: AuthViewModelActions) -> AuthViewModel {
        return DefaultAuthViewModel(authUseCase: createAuthUseCase(),
                                    actions: actions)
    }
    
    // MARK: Home
    
    func createHomeViewController(actions: HomeViewModelActions) -> HomeViewController {
        return HomeViewController.create(with: createHomeViewModel(actions: actions))
    }
    
    func createHomeViewModel(actions: HomeViewModelActions) -> HomeViewModel {
        return DefaultHomeViewModel(homeUseCase: createHomeUseCase(), actions: actions)
    }
}

// MARK: - SceneDependable implementation

extension SceneDependencies: SceneDependable {
    
    func createAuthFlowCoordinator(navigationController: UINavigationController) -> AuthFlowCoordinator {
        return AuthFlowCoordinator(navigationController: navigationController, dependencies: self)
    }
    
    func createHomeFlowCoordinator(navigationController: UINavigationController) -> HomeFlowCoordinator {
        return HomeFlowCoordinator(navigationController: navigationController, dependencies: self)
    }
}

// MARK: - AuthFlowCoordinatorDependencies implementation

extension SceneDependencies: AuthFlowCoordinatorDependencies {}

// MARK: - HomeFlowCoordinatorDependencies implementation

extension SceneDependencies: HomeFlowCoordinatorDependencies {}

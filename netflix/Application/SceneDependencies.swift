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
    func createTabBarFlowCoordinator(navigationController: UINavigationController) -> TabBarFlowCoordinator
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
    
    // MARK: Repositories
    
    func createAuthRepository() -> AuthRepository {
        return DefaultAuthRepository(dataTransferService: dependencies.dataTransferService,
                                     cache: authResponseCache)
    }
    
    // MARK: Auth
    
    func createAuthViewController(actions: AuthViewModelActions) -> AuthViewController {
        return AuthViewController.create(with: createAuthViewModel(actions: actions))
    }
    
    func createAuthViewModel(actions: AuthViewModelActions) -> AuthViewModel {
        return DefaultAuthViewModel(authUseCase: createAuthUseCase(),
                                    actions: actions)
    }
    
    // MARK: TabBar
    
    func createTabBarController(actions: HomeViewModelActions) -> HomeTabBarController {
        return HomeTabBarController.create(with: [createHomeViewController(actions: actions)])
    }
    
    // MARK: TabBar > Home
    
    func createHomeViewController(actions: HomeViewModelActions) -> HomeTableViewController {
        return HomeTableViewController.create(with: createHomeViewModel())
    }
    
    func createHomeViewModel() -> HomeViewModel {
        return DefaultHomeViewModel(actions: nil)
    }
}

// MARK: - SceneDependable implementation

extension SceneDependencies: SceneDependable {
    
    func createAuthFlowCoordinator(navigationController: UINavigationController) -> AuthFlowCoordinator {
        return AuthFlowCoordinator(navigationController: navigationController, dependencies: self)
    }
    
    func createTabBarFlowCoordinator(navigationController: UINavigationController) -> TabBarFlowCoordinator {
        return TabBarFlowCoordinator(navigationController: navigationController, dependencies: self)
    }
}

// MARK: - AuthFlowCoordinatorDependencies implementation

extension SceneDependencies: AuthFlowCoordinatorDependencies {}

// MARK: - TabBarFlowCoordinatorDependencies implementation

extension SceneDependencies: TabBarFlowCoordinatorDependencies {}

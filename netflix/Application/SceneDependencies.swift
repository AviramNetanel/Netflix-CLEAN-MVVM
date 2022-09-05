//
//  SceneDependencies.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import UIKit

// MARK: - SceneDependable protocol

protocol SceneDependable {
    func createFlowCoordinator(navigationController: UINavigationController) -> AuthFlowCoordinator
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
    
    // MARK: Home
    
    func createHomeViewController(actions: HomeViewModelActions) -> HomeViewController {
        return HomeViewController.create(with: createHomeViewModel())
    }
    
    func createHomeViewModel() -> HomeViewModel {
        return DefaultHomeViewModel(actions: nil)
    }
}

// MARK: - SceneDependable implementation

extension SceneDependencies: SceneDependable {
    func createFlowCoordinator(navigationController: UINavigationController) -> AuthFlowCoordinator {
        return AuthFlowCoordinator(navigationController: navigationController, dependencies: self)
    }
}

// MARK: - FlowCoordinatorDependencies implementation

extension SceneDependencies: AuthFlowCoordinatorDependencies {}

//
//  SceneDependencies.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import UIKit

// MARK: - SceneDependable protocol

protocol SceneDependable {
    func createFlowCoordinator(navigationController: UINavigationController) -> FlowCoordinator
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
        return AuthViewController.create(with: createAuthViewModel())
    }
    
    func createAuthViewModel() -> AuthViewModel {
        return DefaultAuthViewModel(authUseCase: createAuthUseCase(),
                                    actions: nil)
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
    func createFlowCoordinator(navigationController: UINavigationController) -> FlowCoordinator {
        return FlowCoordinator(navigationController: navigationController, dependencies: self)
    }
}

// MARK: - FlowCoordinatorDependencies implementation

extension SceneDependencies: FlowCoordinatorDependencies {
    func instantiateViewController(for scene: FlowCoordinator.Scene) -> UIViewController {
        switch scene {
        case .auth:
            return createAuthViewController(actions: .init())
        case .home:
            return createHomeViewController(actions: .init())
        }
    }
}

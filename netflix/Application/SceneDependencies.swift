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
    lazy var mediaResponseCache: MediaResponseStorage = MediaResponseStorage()
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: UseCases
    
    func createAuthUseCase() -> AuthUseCase {
        return AuthUseCase(authRepository: createAuthRepository())
    }
    
    func createHomeUseCase() -> HomeUseCase {
        return HomeUseCase(
            sectionsRepository: createSectionsRepository(),
            mediaRepository: createMediaRepository(),
            myListRepository: createMyListRepository())
    }
    
    func createDetailUseCase() -> DetailUseCase {
        return DetailUseCase(
            seasonsRepository: createSeasonsRepoistory())
    }
    
    // MARK: Repositories
    
    func createAuthRepository() -> AuthRepository {
        return AuthRepository(
            dataTransferService: dependencies.dataTransferService,
            cache: authResponseCache)
    }
    
    func createSectionsRepository() -> SectionRepository {
        return SectionRepository(
            dataTransferService: dependencies.dataTransferService)
    }
    
    func createMediaRepository() -> MediaRepository {
        return MediaRepository(
            dataTransferService: dependencies.dataTransferService,
            cache: mediaResponseCache)
    }
    
    func createSeasonsRepoistory() -> SeasonRepository {
        return SeasonRepository(dataTransferService: dependencies.dataTransferService)
    }
    
    func createMyListRepository() -> MyListRepository {
        return MyListRepository(dataTransferService: dependencies.dataTransferService)
    }
    
    // MARK: - Scenes
    
    // MARK: AuthScene
    
    func createAuthViewController(actions: AuthViewModelActions) -> AuthViewController {
        return .create(with: createAuthViewModel(actions: actions))
    }
    
    func createAuthViewModel(actions: AuthViewModelActions) -> AuthViewModel {
        return .create(authUseCase: createAuthUseCase(),
                       actions: actions)
    }
    
    // MARK: HomeView
    
    func createHomeViewController(actions: HomeViewModelActions) -> HomeViewController {
        return .create(with: createHomeViewModel(actions: actions))
    }
    
    func createHomeViewModel(actions: HomeViewModelActions) -> HomeViewModel {
        return .create(homeUseCase: createHomeUseCase(),
                       actions: actions)
    }
    
    // MARK: DetailView
    
    func createDetailViewController() -> DetailViewController {
        return .create(with: createDetailViewModel())
    }
    
    func createDetailViewModel() -> DetailViewModel {
        return .create(detailUseCase: createDetailUseCase())
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

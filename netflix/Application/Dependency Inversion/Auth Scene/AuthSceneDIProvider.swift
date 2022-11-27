//
//  AuthSceneDIProvider.swift
//  netflix
//
//  Created by Zach Bazov on 26/11/2022.
//

import UIKit.UINavigationController

// MARK: - AuthSceneDIProvider class

final class AuthSceneDIProvider {
    
    private weak var appFlowCoordinator: AppFlowCoordinator!
    private weak var appSceneDIProvider: AppSceneDIProvider!
    
    init(appFlowCoordinator: AppFlowCoordinator) {
        self.appFlowCoordinator = appFlowCoordinator
        self.appSceneDIProvider = appFlowCoordinator.appSceneDIProvider
    }
}

// MARK: - AuthFlowCoordinatorDependencies implementation

extension AuthSceneDIProvider: AuthFlowCoordinatorDependencies {
    
    // MARK: UseCases (Domain)
    
    func createAuthUseCase() -> AuthUseCase {
        return AuthUseCase(authRepository: createAuthRepository())
    }
    
    // MARK: Repositories (Data)
    
    func createAuthRepository() -> AuthRepository {
        return AuthRepository(dataTransferService: appSceneDIProvider.dataTransferService,
                              cache: appSceneDIProvider.authResponseCache)
    }
    
    // MARK: AuthView (Presentation)
    
    func createAuthViewModelActions() -> AuthViewModelActions {
        return AuthViewModelActions(authFlowCoordinator: appFlowCoordinator.authFlowCoordinator)
    }
    
    func createAuthViewController() -> AuthViewController {
        return .create(with: createAuthViewModel())
    }
    
    func createAuthViewModel() -> AuthViewModel {
        return AuthViewModel(authUseCase: createAuthUseCase(), actions: createAuthViewModelActions())
    }
}

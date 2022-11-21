//
//  AppDependencies.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import Foundation

// MARK: - AppDependencies class

final class AppDependencies {
    
    private lazy var configuration = AppConfiguration()
    
    private lazy var dataTransferService: DataTransferService = {
        let url = URL(string: configuration.apiScheme + "://" + configuration.apiHost)!
        let config = NetworkConfig(baseURL: url)
        let networkService = NetworkService(config: config)
        return DataTransferService(with: networkService)
    }()
    
    private(set) lazy var authService = AuthService()
    
    func createSceneDependencies() -> SceneDependencies {
        let dependencies = SceneDependencies.Dependencies(dataTransferService: dataTransferService,
                                                          authService: authService)
        return SceneDependencies(dependencies: dependencies)
    }
}

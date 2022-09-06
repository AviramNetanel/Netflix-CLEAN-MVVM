//
//  AppDependencies.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import Foundation

// MARK: - AppDependencies class

final class AppDependencies {
    
    lazy var configuration = AppConfiguration()
    
    lazy var dataTransferService: DataTransferService = {
        let url = URL(string: configuration.apiScheme + "://" + configuration.apiHost)!
        let config = NetworkConfig(baseURL: url)
        let defaultNetworkService = DefaultNetworkService(config: config)
        return DefaultDataTransferService(with: defaultNetworkService)
    }()
    
    func createSceneDependencies() -> SceneDependencies {
        let dependencies = SceneDependencies.Dependencies(dataTransferService: dataTransferService)
        return SceneDependencies(dependencies: dependencies)
    }
}

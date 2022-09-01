//
//  AppDependencies.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import Foundation

// MARK: - Dependable protocol

protocol Dependable {
    func createSceneDependencies() -> Dependable?
}

// MARK: - Dependable default implementation

extension Dependable {
    func createSceneDependencies() -> Dependable? { return nil }
}

// MARK: - AppDependencies class

final class AppDependencies {
    
    lazy var configuration = AppConfiguration()
    
    lazy var dataTransferService: DataTransferService = {
        let config = NetworkConfig(baseURL: URL(string: configuration.apiScheme + "://" + configuration.apiHost)!)
        let defaultNetworkService = DefaultNetworkService(config: config)
        return DefaultDataTransferService(with: defaultNetworkService)
    }()
}

// MARK: - Dependable implementation

extension AppDependencies: Dependable {
    
    func createSceneDependencies() -> Dependable? {
        let dependencies = SceneDependencies.Dependencies(dataTransferService: dataTransferService)
        return SceneDependencies(dependencies: dependencies) as Dependable
    }
}

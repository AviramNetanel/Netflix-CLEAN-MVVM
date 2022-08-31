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
}

// MARK: - Dependable implementation

extension AppDependencies: Dependable {
    
    func createSceneDependencies() -> Dependable? {
        let dependencies = SceneDependencies.Dependencies()
        return SceneDependencies(dependencies: dependencies) as Dependable
    }
}

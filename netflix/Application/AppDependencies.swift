//
//  AppDependencies.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import UIKit

enum AppScene {
    case home
}

protocol Dependable {
    
}

protocol AppDependencies {
    func createScene(for scene: AppScene) -> Dependable
}

final class DefaultAppDependencies {
    
    lazy var configuration = AppConfiguration()
}

extension DefaultAppDependencies: AppDependencies {
    func createScene(for scene: AppScene) -> Dependable {
        switch scene {
        case .home:
            let dependencies = HomeDependencies.Dependencies()
            return HomeDependencies(dependencies: dependencies) as Dependable
        }
    }
}

//
//  HomeTabBarController.swift
//  netflix
//
//  Created by Zach Bazov on 07/09/2022.
//

import UIKit

// MARK: - HomeTabBarController class

final class HomeTabBarController: UITabBarController {
    
    private var appFlowCoordinator: AppFlowCoordinator! {
        sceneDelegate?.appFlowCoordinator
    }
    
    private var sceneDependencies: SceneDependencies! {
        appFlowCoordinator?.sceneDependencies
    }
    
    private var homeViewController: HomeViewController! {
        return appFlowCoordinator?.homeFlowCoordinator?.viewController as? HomeViewController
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        appFlowCoordinator?.create(for: .home)
        setViewControllers([homeViewController], animated: false)
    }
}

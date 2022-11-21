//
//  HomeTabBarController.swift
//  netflix
//
//  Created by Zach Bazov on 07/09/2022.
//

import UIKit

// MARK: - HomeTabBarController class

final class HomeTabBarController: UITabBarController {
    
    private(set) var homeViewController: HomeViewController!
    
    static func create(with homeViewController: HomeViewController) -> HomeTabBarController {
        let view = Storyboard(
            withOwner: HomeTabBarController.self,
            launchingViewController: HomeTabBarController.self)
            .instantiate() as! HomeTabBarController
        view.homeViewController = homeViewController
        view.setViewControllers([view.homeViewController], animated: false)
        return view
    }
}

//
//  TabBarController.swift
//  netflix
//
//  Created by Zach Bazov on 07/09/2022.
//

import UIKit

// MARK: - TabBarController class

final class TabBarController: UITabBarController {
    
    private(set) var homeViewController: HomeViewController!
    
    static func create(with viewControllers: [UIViewController]) -> TabBarController {
        let view = Storyboard(
            withOwner: TabBarController.self,
            launchingViewController: TabBarController.self)
            .instantiate() as! TabBarController
        view.homeViewController = viewControllers.first as? HomeViewController
        view.setViewControllers(viewControllers, animated: false)
        return view
    }
}

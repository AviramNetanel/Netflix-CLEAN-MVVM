//
//  HomeTabBarController.swift
//  netflix
//
//  Created by Zach Bazov on 06/09/2022.
//

import UIKit

// MARK: - HomeTabBarController class

final class HomeTabBarController: UITabBarController, StoryboardInstantiable {
    
    static func create(with viewControllers: [UIViewController]) -> HomeTabBarController {
        let view = HomeTabBarController.instantiateViewController()
        return view
    }
}

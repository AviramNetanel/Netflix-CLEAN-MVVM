//
//  BackButtonEmptyTitleNavigationBarBehavior.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import UIKit

struct BackButtonEmptyTitleNavigationBarBehavior: ViewControllerLifecycleBehavior {
    
    func viewDidLoad(viewController: UIViewController) {
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

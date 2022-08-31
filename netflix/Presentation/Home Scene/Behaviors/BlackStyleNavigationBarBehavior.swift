//
//  BlackStyleNavigationBarBehavior.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import UIKit

struct BlackStyleNavigationBarBehavior: ViewControllerLifecycleBehavior {
    
    func viewDidLoad(viewController: UIViewController) {
        viewController.navigationController?.navigationBar.barStyle = .black
    }
}

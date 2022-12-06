//
//  DetailViewCoordinator.swift
//  netflix
//
//  Created by Zach Bazov on 05/12/2022.
//

import UIKit

// MARK: - DetailViewCoordinator class

final class DetailViewCoordinator: Coordinate {
    
    enum Screen {
        case detail
    }
    
    weak var viewController: DetailViewController?
    
    func showScreen(_ screen: Screen) {
        
    }
}

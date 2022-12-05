//
//  Application.swift
//  netflix
//
//  Created by Zach Bazov on 05/12/2022.
//

import UIKit

final class Application {
    
    static let current = Application()
    
    let coordinator = AppCoordinator()
    
    private init() {}
    
    func root(in window: UIWindow?) {
        coordinator.window = window
        
        if coordinator.authResponseCache.lastKnownUser != nil {
            coordinator.showScreen(.tabBar)
            return
        }
        coordinator.showScreen(.auth)
    }
}

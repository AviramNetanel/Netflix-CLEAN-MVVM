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
    let configuration = AppConfiguration()
    let authService = AuthService()
    
    private(set) lazy var dataTransferService: DataTransferService = {
        let url = URL(string: configuration.apiScheme + "://" + configuration.apiHost)!
        let config = NetworkConfig(baseURL: url)
        let networkService = NetworkService(config: config)
        return DataTransferService(with: networkService)
    }()
    private(set) lazy var authResponseCache: AuthResponseStorage = AuthResponseStorage(authService: authService)
    private(set) lazy var mediaResponseCache: MediaResponseStorage = MediaResponseStorage()
    
    private init() {}
    
    func root(in window: UIWindow?) {
        coordinator.window = window
        
        if authResponseCache.lastKnownUser != nil {
            coordinator.showScreen(.tabBar)
            return
        }
        coordinator.showScreen(.auth)
    }
}

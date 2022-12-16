//
//  Application.swift
//  netflix
//
//  Created by Zach Bazov on 05/12/2022.
//

import UIKit

final class Application {
    static let current = Application()
    
    let rootCoordinator = RootCoordinator()
    let configuration = AppConfiguration()
    let authService = AuthService()
    
    private(set) lazy var dataTransferService: DataTransferService = createDataTransferService()
    private(set) lazy var authResponseCache: AuthResponseStorage = AuthResponseStorage(authService: authService)
    private(set) lazy var mediaResponseCache: MediaResponseStorage = MediaResponseStorage()
    
    private init() {}
    
    func root(in window: UIWindow?) {
        rootCoordinator.window = window
        
        if authService.latestCachedUser != nil {
            rootCoordinator.showScreen(.tabBar)
            return
        }
        rootCoordinator.showScreen(.auth)
    }
    
    private func createDataTransferService() -> DataTransferService {
        let url = URL(string: configuration.apiScheme + "://" + configuration.apiHost)!
        let config = NetworkConfig(baseURL: url)
        let networkService = NetworkService(config: config)
        return DataTransferService(with: networkService)
    }
}

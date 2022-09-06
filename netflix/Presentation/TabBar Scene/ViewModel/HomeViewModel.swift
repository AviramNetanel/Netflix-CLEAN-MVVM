//
//  HomeViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 05/09/2022.
//

import Foundation

// MARK: - HomeViewModelActions struct

struct HomeViewModelActions {
    
}

// MARK: - HomeViewModel protocol

protocol HomeViewModel {
    
}

// MARK: - HomeViewModel class

final class DefaultHomeViewModel: HomeViewModel {
    
    //private let authUseCase: AuthUseCase
    private let actions: HomeViewModelActions
    
    private var task: Cancellable? {
        willSet {
            task?.cancel()
        }
    }
    
    init(//authUseCase: AuthUseCase,
         actions: HomeViewModelActions? = nil) {
        //self.authUseCase = authUseCase
        print("init")
        self.actions = actions ?? .init()
    }
    
    
    
    // MARK: Private
    
    
}

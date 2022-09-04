//
//  HomeViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 05/09/2022.
//

import Foundation

// MARK: - HomeViewModel

struct HomeViewModelActions {
    
}

// MARK: - HomeViewModel

protocol HomeViewModel {
    
}

// MARK: - HomeViewModel

final class DefaultHomeViewModel: HomeViewModel {
    
    private let authUseCase: AuthUseCase
    private let actions: HomeViewModelActions
    
    private var authLoadTask: Cancellable? {
        willSet {
            authLoadTask?.cancel()
        }
    }
    
    init(authUseCase: AuthUseCase, actions: HomeViewModelActions? = nil) {
        self.authUseCase = authUseCase
        self.actions = actions ?? .init()
        
        self.signIn()
    }
    
    // MARK:
    
    func signIn() {
        let requestDTO = AuthRequestDTO(user: UserDTO(email: "qwe@gmail.com", password: "qweqweqwe"))
        let authQuery = AuthQuery(user: requestDTO.user)
        authorization(query: authQuery)
    }
    
    // MARK: Private
    
    private func authorization(query: AuthQuery) {
        authLoadTask = authUseCase.execute(requestValue: .init(query: query), cached: { _ in }, completion: { result in
            switch result {
            case .success(let response):
                print("r", response)
            case .failure(let error):
                print("e", error)
            }
        })
    }
}

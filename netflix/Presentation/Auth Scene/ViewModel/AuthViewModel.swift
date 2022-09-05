//
//  AuthViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 05/09/2022.
//

import Foundation

// MARK: - AuthViewModelActions struct

struct AuthViewModelActions {
    
}

// MARK: - AuthViewModel protocol

protocol AuthViewModel {
    
}

// MARK: - AuthViewModel class

final class DefaultAuthViewModel: AuthViewModel {
    
    private let authUseCase: AuthUseCase
    private let actions: AuthViewModelActions?
    
    private var authorizationTask: Cancellable? {
        willSet { authorizationTask?.cancel() }
    }
    
    init(authUseCase: AuthUseCase, actions: AuthViewModelActions? = nil) {
        self.authUseCase = authUseCase
        self.actions = actions
        
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
        authorizationTask = authUseCase.execute(requestValue: .init(query: query), cached: { _ in }, completion: { result in
            switch result {
            case .success(let response):
                print("r", response)
            case .failure(let error):
                print("e", error)
            }
        })
    }
}

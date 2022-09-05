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
        willSet {
            authorizationTask?.cancel()
        }
    }
    
    init(authUseCase: AuthUseCase, actions: AuthViewModelActions? = nil) {
        self.authUseCase = authUseCase
        self.actions = actions
        
//        self.signIn()
//        self.signUp()
    }
    
    // MARK:
    
    func signUp() {
        let userDTO = UserDTO(name: "new",
                              email: "newone@gmail.com",
                              password: "newpassword",
                              passwordConfirm: "newpassword",
                              role: "user",
                              active: true)
        let requestDTO = AuthRequestDTO(user: userDTO)
        let authQuery = AuthQuery(user: requestDTO.user)
        register(query: authQuery)
    }
    
    func signIn() {
        let userDTO = UserDTO(email: "newone@gmail.com", password: "newpassword")
        let requestDTO = AuthRequestDTO(user: userDTO)
        let authQuery = AuthQuery(user: requestDTO.user)
        authorization(query: authQuery)
    }
    
    // MARK: Private
    
    private func register(query: AuthQuery) {
        authorizationTask = authUseCase.execute(requestValue: .init(method: .signup, query: query),
                                                cached: { _ in },
                                                completion: { result in
            switch result {
            case .success(let response):
                print("signUpResponse: \(response)")
            case .failure(let error):
                print("signUpError \(error)")
            }
        })
    }
    
    private func authorization(query: AuthQuery) {
        authorizationTask = authUseCase.execute(requestValue: .init(method: .signin, query: query),
                                                cached: { _ in },
                                                completion: { result in
            switch result {
            case .success(let response):
                print("signInResponse \(response)")
            case .failure(let error):
                print("signInError \(error)")
            }
        })
    }
}

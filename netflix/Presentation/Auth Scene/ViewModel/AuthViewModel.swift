//
//  AuthViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 05/09/2022.
//

import Foundation

// MARK: - AuthViewModelActions struct

struct AuthViewModelActions {
    let showSignInViewController: () -> Void
    let showSignUpViewController: () -> Void
}

// MARK: - AuthViewModelInput protocol

protocol AuthViewModelInput {
    func viewDidLoad()
    func didSignUp()
    func didSignIn()
    func signInButtonDidTap()
}

// MARK: - AuthViewModelOutput protocol

protocol AuthViewModelOutput {
    
}

//

protocol AuthViewModel {}

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
        
//        self.didSignUp()
//        self.didSignIn()
    }
    
    // MARK: Private
    
    private func signUp(query: AuthQuery) {
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
    
    private func signIn(query: AuthQuery) {
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

// MARK: - AuthViewModelInput implementation

extension DefaultAuthViewModel: AuthViewModelInput {
    
    func viewDidLoad() {}
    
    func didSignUp() {
        let userDTO = UserDTO(name: "new2",
                              email: "newone2@gmail.com",
                              password: "newpassword",
                              passwordConfirm: "newpassword",
                              role: "user",
                              active: true)
        let requestDTO = AuthRequestDTO(user: userDTO)
        let authQuery = AuthQuery(user: requestDTO.user)
        
        signUp(query: authQuery)
    }
    
    func didSignIn() {
        let userDTO = UserDTO(email: "newone2@gmail.com", password: "newpassword")
        let requestDTO = AuthRequestDTO(user: userDTO)
        let authQuery = AuthQuery(user: requestDTO.user)
        
        signIn(query: authQuery)
    }
    
    @objc
    func signInButtonDidTap() {
        actions?.showSignInViewController()
    }
    
    @objc
    func signUpButtonDidTap() {
        actions?.showSignUpViewController()
    }
}

// MARK: - AuthViewModelOutput implementation

extension DefaultAuthViewModel: AuthViewModelOutput {
    
}

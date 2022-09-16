//
//  AuthViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 05/09/2022.
//

import Foundation

// MARK: - AuthViewModelActions struct

struct AuthViewModelActions {
    let presentSignInViewController: () -> Void
    let presentSignUpViewController: () -> Void
    let presentHomeViewController: () -> Void
}

// MARK: - AuthViewModelInput protocol

protocol AuthViewModelInput {
    func viewDidLoad()
    func signUp(query: AuthQuery,
                completion: @escaping (Result<AuthResponseDTO, Error>) -> Void)
    func signIn(query: AuthQuery,
                completion: @escaping (Result<AuthResponseDTO, Error>) -> Void)
    func signInButtonDidTap()
}

// MARK: - AuthViewModel protocol

protocol AuthViewModel: AuthViewModelInput {}

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
    }
}

// MARK: - AuthViewModel implementation

extension DefaultAuthViewModel {
    
    func viewDidLoad() {
        // should be fetchrequested from coredata.
        let userDTO = UserDTO(email: "qwe@gmail.com", password: "qweqweqwe")
        let requestDTO = AuthRequestDTO(user: userDTO)
        let authQuery = AuthQuery(user: requestDTO.user)
        
        signIn(query: authQuery) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.actions?.presentHomeViewController()
                }
            case .failure(let error):
                printIfDebug("Unresolved error \(error)")
            }
        }
    }
    
    func signUp(query: AuthQuery,
                completion: @escaping (Result<AuthResponseDTO, Error>) -> Void) {
        authorizationTask = authUseCase.execute(requestValue: .init(method: .signup, query: query),
                                                cached: { _ in },
                                                completion: { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    func signIn(query: AuthQuery,
                completion: @escaping (Result<AuthResponseDTO, Error>) -> Void) {
        authorizationTask = authUseCase.execute(requestValue: .init(method: .signin, query: query),
                                                cached: { response in
            if let response = response {
                return completion(.success(response))
            }
        },
                                                completion: { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    @objc
    func signInButtonDidTap() {
        actions?.presentSignInViewController()
    }
    
    @objc
    func signUpButtonDidTap() {
        actions?.presentSignUpViewController()
    }
}

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

// MARK: - ViewModelInput protocol

private protocol ViewModelInput {
    func viewDidLoad()
    func signUp(query: AuthQuery,
                completion: @escaping (Result<AuthResponseDTO, Error>) -> Void)
    func signIn(query: AuthQuery,
                completion: @escaping (Result<AuthResponseDTO, Error>) -> Void)
    func signInButtonDidTap()
}

// MARK: - ViewModelOutput protocol

private protocol ViewModelOutput {
    var authUseCase: AuthUseCase { get }
    var actions: AuthViewModelActions? { get }
    var authorizationTask: Cancellable? { get }
}

// MARK: - ViewModel typealias

private typealias ViewModel = ViewModelInput & ViewModelOutput

// MARK: - AuthViewModel class

final class AuthViewModel: ViewModel {
    
    fileprivate let authUseCase: AuthUseCase
    fileprivate(set) var actions: AuthViewModelActions?
    
    fileprivate var authorizationTask: Cancellable? {
        willSet {
            authorizationTask?.cancel()
        }
    }
    
    init(authUseCase: AuthUseCase, actions: AuthViewModelActions? = nil) {
        self.authUseCase = authUseCase
        self.actions = actions
    }
}

// MARK: - ViewModelInput implementation

extension AuthViewModel {
    
    func viewDidLoad() {
        // should be fetchrequested from coredata.
        let userDTO = UserDTO(email: "qwe@gmail.com", password: "qweqweqwe")
        let requestDTO = AuthRequestDTO(user: userDTO)
        let authQuery = AuthQuery(user: requestDTO.user)
        
        signIn(query: authQuery) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                DispatchQueue.main.async { self.actions?.presentHomeViewController() }
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

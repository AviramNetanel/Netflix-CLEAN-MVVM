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
    func signUp(request: AuthRequest,
                completion: @escaping (Result<AuthResponseDTO, Error>) -> Void)
    func signIn(request: AuthRequest,
                completion: @escaping (Result<AuthResponseDTO, Error>) -> Void)
    func signInButtonDidTap()
}

// MARK: - ViewModelOutput protocol

private protocol ViewModelOutput {
    var authUseCase: AuthUseCase! { get }
    var actions: AuthViewModelActions? { get }
    var authorizationTask: Cancellable? { get }
    var user: User? { get }
}

// MARK: - ViewModel typealias

private typealias ViewModel = ViewModelInput & ViewModelOutput

// MARK: - AuthViewModel class

final class AuthViewModel: ViewModel {
    
    fileprivate var authUseCase: AuthUseCase!
    fileprivate(set) var actions: AuthViewModelActions?
    fileprivate var authorizationTask: Cancellable? { willSet { authorizationTask?.cancel() } }
    fileprivate(set) var user: User?
    
    deinit {
        user = nil
        authorizationTask = nil
        actions = nil
        authUseCase = nil
    }
    
    static func create(authUseCase: AuthUseCase,
                       actions: AuthViewModelActions? = nil) -> AuthViewModel {
        let viewModel = AuthViewModel()
        viewModel.authUseCase = authUseCase
        viewModel.actions = actions
        return viewModel
    }
    
    private func userDidAuthorize() {
        authUseCase.authRepository.cache.performCachedAuthorizationSession { [weak self] query in
            guard let self = self else { return }
            self.signIn(request: query) { result in
                switch result {
                case .success(let response):
                    self.user = response.data?.toDomain()
                    self.user?.token = response.token
                    
                    asynchrony { self.actions?.presentHomeViewController() }
                case .failure(let error):
                    printIfDebug("Unresolved error \(error)")
                }
            }
        }
    }
}

// MARK: - ViewModelInput implementation

extension AuthViewModel {
    
    func viewDidLoad() {
        userDidAuthorize()
    }
    
    func signUp(request: AuthRequest,
                completion: @escaping (Result<AuthResponseDTO, Error>) -> Void) {
        authorizationTask = authUseCase.execute(
            requestValue: .init(method: .signup, request: request),
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
    
    func signIn(request: AuthRequest,
                completion: @escaping (Result<AuthResponseDTO, Error>) -> Void) {
        authorizationTask = authUseCase.execute(
            requestValue: .init(method: .signin, request: request),
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

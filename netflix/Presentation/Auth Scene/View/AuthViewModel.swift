//
//  AuthViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 05/09/2022.
//

import Foundation


//// MARK: - ViewModelInput protocol
//
//private protocol ViewModelInput {
//    func viewDidLoad()
//    func signUp(request: AuthRequest, completion: @escaping (Result<AuthResponseDTO, Error>) -> Void)
//    func signIn(request: AuthRequest, completion: @escaping (Result<AuthResponseDTO, Error>) -> Void)
//    func signInButtonDidTap()
//    func signUpButtonDidTap()
//}
//
//// MARK: - ViewModelOutput protocol
//
//private protocol ViewModelOutput {
//    var task: Cancellable? { get }
//    var authUseCase: AuthUseCase { get }
//    var actions: AuthViewModelActions { get }
//}
//
//// MARK: - ViewModel typealias
//
//private typealias ViewModel = ViewModelInput & ViewModelOutput

// MARK: - AuthViewModel class

final class AuthViewModel: ViewModel {
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
    
    var coordinator: AuthCoordinator?
    
    fileprivate var task: Cancellable? { willSet { task?.cancel() } }
    fileprivate let authUseCase: AuthUseCase
    
    init(authUseCase: AuthUseCase) {
        self.authUseCase = authUseCase
    }
    
    deinit {
        task = nil
    }
}

// MARK: - ViewModelInput implementation

extension AuthViewModel {
    
    func viewDidLoad() {
        if authUseCase.authRepository.cache.lastKnownUser != nil {
            userDidAuthorize()
        }
    }
    
    func userDidAuthorize() {
        authUseCase.authRepository.cache.performCachedAuthorizationSession { [weak self] query in
            guard let self = self else { return }
            self.signIn(request: query) { result in
                if case .success = result {
                    //asynchrony { Application.current.coordinator.showScreen(.tabBar) }
                }
                if case let .failure(error) = result { printIfDebug("Unresolved error \(error)") }
            }
        }
    }
    
    func signUp(request: AuthRequest,
                completion: @escaping (Result<AuthResponseDTO, Error>) -> Void) {
        task = authUseCase.execute(
            requestValue: .init(method: .signup, request: request),
            cached: { _ in },
            completion: { result in
                if case let .success(responseDTO) = result { completion(.success(responseDTO)) }
                if case let .failure(error) = result { completion(.failure(error)) }
            })
    }
    
    func signIn(request: AuthRequest,
                completion: @escaping (Result<AuthResponseDTO, Error>) -> Void) {
        task = authUseCase.execute(
            requestValue: .init(method: .signin, request: request),
            cached: { response in
                if let response = response { completion(.success(response)) }
            },
            completion: { result in
                if case let .success(responseDTO) = result { completion(.success(responseDTO)) }
                if case let .failure(error) = result { completion(.failure(error)) }
            })
    }
}

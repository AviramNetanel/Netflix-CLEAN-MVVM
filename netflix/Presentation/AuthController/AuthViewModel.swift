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
    fileprivate var task: Cancellable? { willSet { task?.cancel() } }
    
    var coordinator: AuthCoordinator?
    private(set) var useCase: AuthUseCase
    
    init() {
        let authService = Application.current.coordinator.authService
        let dataTransferService = Application.current.coordinator.dataTransferService
        let authResponseCache = AuthResponseStorage(authService: authService)
        let authRepository = AuthRepository(dataTransferService: dataTransferService, cache: authResponseCache)
        self.useCase = AuthUseCase(authRepository: authRepository)
    }
    
    deinit {
        task = nil
    }
    
    func transform(input: Void) {}
}

// MARK: - ViewModelInput implementation

extension AuthViewModel {
    
    func viewDidLoad() {
        if useCase.authRepository.cache.lastKnownUser != nil {
            userDidAuthorize()
        }
    }
    
    func userDidAuthorize() {
        useCase.authRepository.cache.performCachedAuthorizationSession { [weak self] query in
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
        task = useCase.execute(
            requestValue: .init(method: .signup, request: request),
            cached: { _ in },
            completion: { result in
                if case let .success(responseDTO) = result { completion(.success(responseDTO)) }
                if case let .failure(error) = result { completion(.failure(error)) }
            })
    }
    
    func signIn(request: AuthRequest,
                completion: @escaping (Result<AuthResponseDTO, Error>) -> Void) {
        task = useCase.execute(
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

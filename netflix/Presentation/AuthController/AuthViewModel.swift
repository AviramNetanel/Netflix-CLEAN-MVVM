//
//  AuthViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 05/09/2022.
//

import Foundation

// MARK: - AuthViewModel class
final class AuthViewModel: ViewModel {
    private var task: Cancellable? {
        willSet { task?.cancel() }
    }
    
    var coordinator: AuthCoordinator?
    let useCase: AuthUseCase
    var authResponseCache: AuthResponseStorage
    
    init() {
        let authService = Application.current.authService
        let dataTransferService = Application.current.dataTransferService
        self.authResponseCache = AuthResponseStorage(authService: authService)
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
    
    func cachedAuthorizationSession(_ completion: @escaping () -> Void) {
        useCase.authRepository.cache.performCachedAuthorizationSession { [weak self] request in
            guard let self = self else { return }
            self.signIn(request: request) { result in
                if case let .success(responseDTO) = result {
                    Application.current.authService.user = responseDTO.data
                    Application.current.authService.user.token = responseDTO.token
                    
                    asynchrony { completion() }
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

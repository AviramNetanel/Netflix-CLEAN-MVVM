//
//  SignInViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 07/12/2022.
//

import Foundation

final class SignInViewModel {
    private let viewModel: AuthViewModel
    var email: String?
    var password: String?
    
    init(with viewModel: AuthViewModel) {
        self.viewModel = viewModel
    }
    
    @objc
    func signInButtonDidTap() {
        let userDTO = UserDTO(email: email, password: password)
        let requestDTO = AuthRequestDTO(user: userDTO)
        
        let authService = Application.current.authService
        let coordinator = Application.current.rootCoordinator
        
        viewModel.signIn(request: requestDTO.toDomain()) { result in
            if case let .success(responseDTO) = result {
                let userDTO = responseDTO.data
                userDTO?.token = responseDTO.token
                authService.assignUser(user: userDTO)
                
                coordinator.showScreen(.tabBar)
            }
            if case let .failure(error) = result { print(error) }
        }
    }
}

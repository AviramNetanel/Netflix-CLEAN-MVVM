//
//  SignUpViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 07/12/2022.
//

import Foundation

final class SignUpViewModel {
    private let viewModel: AuthViewModel
    var name: String?
    var email: String?
    var password: String?
    var passwordConfirm: String?
    
    init(with viewModel: AuthViewModel) {
        self.viewModel = viewModel
    }
    
    @objc
    func signUpButtonDidTap() {
        let authService = Application.current.authService
        let coordinator = Application.current.rootCoordinator
        
        let userDTO = UserDTO(name: name,
                              email: email,
                              password: password,
                              passwordConfirm: passwordConfirm)
        let requestDTO = AuthRequestDTO(user: userDTO)
        
        viewModel.signUp(request: requestDTO.toDomain()) { result in
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

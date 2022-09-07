//
//  APIEndpoint.swift
//  netflix
//
//  Created by Zach Bazov on 01/09/2022.
//

import Foundation

// MARK: - APIEndpoint struct

struct APIEndpoint {
    
    // MARK: AuthRepository endpoints
    
    static func signUp(with authRequestDTO: AuthRequestDTO) -> Endpoint<AuthResponseDTO> {
        return Endpoint(path: "api/v1/users/signup",
                        method: .post,
                        bodyParameters: ["name": authRequestDTO.user.name!,
                                         "email": authRequestDTO.user.email!,
                                         "password": authRequestDTO.user.password!,
                                         "passwordConfirm": authRequestDTO.user.passwordConfirm!],
                        bodyEncoding: .jsonSerializationData)
    }
    
    static func signIn(with authRequestDTO: AuthRequestDTO) -> Endpoint<AuthResponseDTO> {
        return Endpoint(path: "api/v1/users/signin",
                        method: .post,
                        bodyParameters: ["email": authRequestDTO.user.email!,
                                         "password": authRequestDTO.user.password!],
                        bodyEncoding: .jsonSerializationData)
    }
    
    // MARK: TVShowsRepository endpoints
    
    static func getTVShows() -> Endpoint<TVShowsResponseDTO> {
        return Endpoint(path: "api/v1/tvshows",
                        method: .get,
                        queryParameters: ["sort": "id"])
    }
    
    // MARK: MoviesRepository endpoints
    
    static func getMovies() -> Endpoint<MoviesResponseDTO> {
        return Endpoint(path: "api/v1/movies",
                        method: .get,
                        queryParameters: ["sort": "id"])
    }
}


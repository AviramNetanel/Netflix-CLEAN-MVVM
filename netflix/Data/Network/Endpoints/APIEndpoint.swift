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
    
    // MARK: SectionsRepository endpoints
    
    static func getSections() -> Endpoint<SectionsResponseDTO> {
        return Endpoint(path: "api/v1/sections",
                        method: .get,
                        queryParameters: ["sort": "id"])
    }
    
    // MARK: MediaRepository endpoints
    
    static func getMedia() -> Endpoint<MediasResponseDTO> {
        return Endpoint(path: "api/v1/media",
                        method: .get,
                        queryParameters: ["sort": "id"])
    }
    
    // MARK: SeasonsRepository endpoints
    
    static func getSeason(with viewModel: EpisodeCollectionViewCellViewModel,
                          season: Int? = 1) -> Endpoint<SeasonResponseDTO> {
        return Endpoint(path: "api/v1/media/\(viewModel.media.slug)/seasons/\(season!)",
                        method: .get)
    }
}


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
    
    static func getAllSections() -> Endpoint<SectionResponseDTO.GET> {
        return Endpoint(path: "api/v1/sections",
                        method: .get,
                        queryParameters: ["sort": "id"])
    }
    
    // MARK: MediaRepository endpoints
    
    static func getAllMedia() -> Endpoint<MediaResponseDTO.GET.Many> {
        return Endpoint(path: "api/v1/media",
                        method: .get,
                        queryParameters: ["sort": "id"])
    }
    
    static func getMedia(with request: MediaRequestDTO.GET.One) -> Endpoint<MediaResponseDTO.GET.One> {
        let assertion = request.id == nil ? request.slug! : request.id!
        return Endpoint(path: "api/v1/media/\(assertion)",
                        method: .get)
    }
    
    // MARK: SeasonsRepository endpoints
    
    static func getSeason(with request: SeasonRequestDTO.GET) -> Endpoint<SeasonResponseDTO.GET> {
        return Endpoint(path: "api/v1/media/\(request.slug!)/seasons/\(request.season!)",
                        method: .get)
    }
    
    // MARK: MyListRepository endpoints
    
    static func getAllMyLists() -> Endpoint<MyListResponseDTO.GET> {
        return Endpoint(path: "api/v1/mylists",
                        method: .get)
    }
    
    static func getMyList(with request: MyListRequestDTO.GET) -> Endpoint<MyListResponseDTO.GET> {
        return Endpoint(path: "api/v1/mylists/\(request.user._id ?? "")",
                        method: .get)
    }
    
    static func updateMyList(with request: MyListRequestDTO.PATCH) -> Endpoint<MyListResponseDTO.PATCH> {
        return Endpoint<MyListResponseDTO.PATCH>(path: "api/v1/mylists/\(request.user)",
                                                 method: .patch,
                                                 bodyParameters: ["user": request.user,
                                                                  "media": request.media],
                                                 bodyEncoding: .jsonSerializationData)
    }
}

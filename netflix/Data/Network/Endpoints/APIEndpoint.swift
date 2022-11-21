//
//  APIEndpoint.swift
//  netflix
//
//  Created by Zach Bazov on 01/09/2022.
//

import Foundation

// MARK: - AuthRepositoryEndpoints protocol

private protocol AuthRepositoryEndpoints {
    static func signUp(with authRequestDTO: AuthRequestDTO) -> Endpoint<AuthResponseDTO>
    static func signIn(with authRequestDTO: AuthRequestDTO) -> Endpoint<AuthResponseDTO>
}

// MARK: - SectionsRepositoryEndpoints protocol

private protocol SectionsRepositoryEndpoints {
    static func getAllSections() -> Endpoint<SectionResponseDTO.GET>
}

// MARK: - MediaRepositoryEndpoints protocol

private protocol MediaRepositoryEndpoints {
    static func getAllMedia() -> Endpoint<MediaResponseDTO.GET.Many>
    static func getMedia(with request: MediaRequestDTO.GET.One) -> Endpoint<MediaResponseDTO.GET.One>
}

// MARK: - SeasonsRepositoryEndpoints protocol

private protocol SeasonsRepositoryEndpoints {
    static func getSeason(with request: SeasonRequestDTO.GET) -> Endpoint<SeasonResponseDTO.GET>
}

// MARK: - MyListRepositoryEndpoints protocol

private protocol MyListRepositoryEndpoints {
    static func getAllMyLists() -> Endpoint<ListResponseDTO.GET>
    static func getMyList(with request: ListRequestDTO.GET) -> Endpoint<ListResponseDTO.GET>
    static func createMyList(with request: ListRequestDTO.POST) -> Endpoint<ListResponseDTO.POST>
    static func updateMyList(with request: ListRequestDTO.PATCH) -> Endpoint<ListResponseDTO.PATCH>
}

// MARK: - APIEndpoint struct

struct APIEndpoint {
    
    // MARK: AuthRepository endpoints
    
    struct AuthRepository: AuthRepositoryEndpoints {
        
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
    }
    
    // MARK: SectionsRepository endpoints
    
    struct SectionsRepository: SectionsRepositoryEndpoints {
        
        static func getAllSections() -> Endpoint<SectionResponseDTO.GET> {
            return Endpoint(path: "api/v1/sections",
                            method: .get,
                            queryParameters: ["sort": "id"])
        }
    }
    
    // MARK: MediaRepository endpoints
    
    struct MediaRepository: MediaRepositoryEndpoints {
        
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
    }
    
    // MARK: SeasonsRepository endpoints
    
    struct SeasonsRepository: SeasonsRepositoryEndpoints {
        
        static func getSeason(with request: SeasonRequestDTO.GET) -> Endpoint<SeasonResponseDTO.GET> {
            return Endpoint(path: "api/v1/media/\(request.slug!)/seasons/\(request.season!)",
                            method: .get)
        }
    }
    
    // MARK: MyListRepository endpoints
    
    struct MyListRepository: MyListRepositoryEndpoints {
        
        static func getAllMyLists() -> Endpoint<ListResponseDTO.GET> {
            return Endpoint(path: "api/v1/mylists",
                            method: .get)
        }
        
        static func getMyList(with request: ListRequestDTO.GET) -> Endpoint<ListResponseDTO.GET> {
            return Endpoint(path: "api/v1/mylists/\(request.user._id ?? "")",
                            method: .get)
        }
        
        static func createMyList(with request: ListRequestDTO.POST) -> Endpoint<ListResponseDTO.POST> {
            return Endpoint(path: "api/v1/mylists/\(request.user)",
                            method: .post,
                            bodyParameters: ["user": request.user,
                                             "media": request.media],
                            bodyEncoding: .jsonSerializationData)
        }
        
        static func updateMyList(with request: ListRequestDTO.PATCH) -> Endpoint<ListResponseDTO.PATCH> {
            return Endpoint(path: "api/v1/mylists/\(request.user)",
                            method: .patch,
                            bodyParameters: ["user": request.user,
                                             "media": request.media],
                            bodyEncoding: .jsonSerializationData)
        }
    }
}

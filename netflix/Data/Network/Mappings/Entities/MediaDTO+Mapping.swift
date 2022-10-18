//
//  MediaDTO+Mapping.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import UIKit

// MARK: - MediaDTO struct

struct MediaDTO: Codable {
    
    let id: String?
    let type: String
    let title: String
    let slug: String
    
    let createdAt: String
    
    let rating: Float
    let description: String
    let cast: String
    let writers: String?
    let duration: String?
    let length: String
    let genres: [String]
    
    let hasWatched: Bool
    let isHD: Bool
    let isExclusive: Bool
    let isNewRelease: Bool
    let isSecret: Bool
    
    struct Resources: Codable {
        let posters: [String]
        let logos: [String]
        let trailers: [String]
        let displayPoster: String
        let displayLogos: [String]
        let previewPoster: String
        let previewUrl: String?
        let presentedPoster: String
        let presentedLogo: String
        let presentedDisplayLogo: String
        let presentedLogoAlignment: String
    }
    
    let resources: Resources
    
    let seasons: [String]?
    let numberOfEpisodes: Int?
}

// MARK: - Mapping

extension MediaDTO {
    func toDomain() -> Media {
        return .init(id: id,
                     type: type,
                     title: title,
                     slug: slug,
                     createdAt: createdAt,
                     rating: rating,
                     description: description,
                     cast: cast,
                     writers: writers ?? "",
                     duration: duration ?? "",
                     length: length,
                     genres: genres,
                     hasWatched: hasWatched,
                     isHD: isHD,
                     isExclusive: isExclusive,
                     isNewRelease: isNewRelease,
                     isSecret: isSecret,
                     resources: resources.toDomain(),
                     seasons: seasons,
                     numberOfEpisodes: numberOfEpisodes)
    }
}

extension MediaDTO.Resources {
    func toDomain() -> Media.Resources {
        return .init(posters: posters,
                     logos: logos,
                     trailers: trailers,
                     displayPoster: displayPoster,
                     displayLogos: displayLogos,
                     previewPoster: previewPoster,
                     previewUrl: previewUrl ?? "",
                     presentedPoster: presentedPoster,
                     presentedLogo: presentedLogo,
                     presentedDisplayLogo: presentedDisplayLogo,
                     presentedLogoAlignment: presentedLogoAlignment)
    }
}

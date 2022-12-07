//
//  Media.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import UIKit

struct MediaResources {
    let posters: [String]
    let logos: [String]
    let trailers: [String]
    let displayPoster: String
    let displayLogos: [String]
    let previewPoster: String
    let previewUrl: String
    let presentedPoster: String
    let presentedLogo: String
    let presentedDisplayLogo: String
    let presentedLogoAlignment: String
}

struct Media {
    let id: String?
    let type: MediaType
    let title: String
    let slug: String
    
    let createdAt: String
    
    let rating: Float
    let description: String
    let cast: String
    let writers: String
    let duration: String
    let length: String
    let genres: [String]
    
    let hasWatched: Bool
    let isHD: Bool
    let isExclusive: Bool
    let isNewRelease: Bool
    let isSecret: Bool
    
    let resources: MediaResources
    
    let seasons: [String]?
    let numberOfEpisodes: Int?
}

extension Media: Equatable {
    static func ==(lhs: Media, rhs: Media) -> Bool { lhs.id == rhs.id }
}

extension Media: Hashable {
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

extension Media {
    func toDTO() -> MediaDTO {
        return .init(id: id,
                     type: type,
                     title: title,
                     slug: slug,
                     createdAt: createdAt,
                     rating: rating,
                     description: description,
                     cast: cast,
                     writers: writers,
                     duration: duration,
                     length: length,
                     genres: genres,
                     hasWatched: hasWatched,
                     isHD: isHD,
                     isExclusive: isExclusive,
                     isNewRelease: isNewRelease,
                     isSecret: isSecret,
                     resources: resources.toDTO(),
                     seasons: seasons,
                     numberOfEpisodes: numberOfEpisodes)
    }
}

extension MediaResources {
    func toDTO() -> MediaResourcesDTO {
        return .init(posters: posters,
                     logos: logos,
                     trailers: trailers,
                     displayPoster: displayPoster,
                     displayLogos: displayLogos,
                     previewPoster: previewPoster,
                     previewUrl: previewUrl,
                     presentedPoster: presentedPoster,
                     presentedLogo: presentedLogo,
                     presentedDisplayLogo: presentedDisplayLogo,
                     presentedLogoAlignment: presentedLogoAlignment)
    }
}

extension Array where Element == Media {
    func toDTO() -> [MediaDTO] {
        return map { $0.toDTO() }
    }
}

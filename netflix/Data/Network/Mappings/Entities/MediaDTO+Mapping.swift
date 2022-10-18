//
//  MediaDTO+Mapping.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import UIKit

// MARK: - MediaDTO struct

struct MediaDTO: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case title
        case slug
        case createdAt
        case rating
        case description
        case cast
        case writers
        case duration
        case length
        case genres
        case hasWatched
        case isHD
        case isExclusive
        case isNewRelease
        case isSecret
        case resources
        case seasons
        case numberOfEpisodes
    }
    
    let id: String?
    let type: String
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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decodeIfPresent(String.self, forKey: .id)
        let type = try container.decode(String.self, forKey: .type)
        let title = try container.decode(String.self, forKey: .title)
        let slug = try container.decode(String.self, forKey: .slug)
        
        let createdAt = try container.decode(String.self, forKey: .createdAt)
        
        let rating = try container.decode(Float.self, forKey: .rating)
        let description = try container.decode(String.self, forKey: .description)
        let cast = try container.decode(String.self, forKey: .cast)
        let writers = try container.decodeIfPresent(String.self, forKey: .writers)
        let duration = try container.decodeIfPresent(String.self, forKey: .duration)
        let length = try container.decode(String.self, forKey: .length)
        let genres = try container.decode([String].self, forKey: .genres)
        
        let hasWatched = try container.decode(Bool.self, forKey: .hasWatched)
        let isHD = try container.decode(Bool.self, forKey: .isHD)
        let isExclusive = try container.decode(Bool.self, forKey: .isExclusive)
        let isNewRelease = try container.decode(Bool.self, forKey: .isNewRelease)
        let isSecret = try container.decode(Bool.self, forKey: .isSecret)
        
        let resources = try container.decode(MediaDTO.Resources.self, forKey: .resources)
        
        let seasons = try container.decodeIfPresent([String].self, forKey: .seasons)
        let numberOfEpisodes = try container.decodeIfPresent(Int.self, forKey: .numberOfEpisodes)
        
        self.id = id
        self.type = type
        self.title = title
        self.slug = slug
        
        self.createdAt = createdAt
        
        self.rating = rating
        self.description = description
        self.cast = cast
        self.writers = writers ?? ""
        self.duration = duration ?? ""
        self.length = length
        self.genres = genres
        
        self.hasWatched = hasWatched
        self.isHD = isHD
        self.isExclusive = isExclusive
        self.isNewRelease = isNewRelease
        self.isSecret = isSecret
        
        self.resources = resources
        
        self.seasons = seasons
        self.numberOfEpisodes = numberOfEpisodes
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encode(title, forKey: .title)
        try container.encode(slug, forKey: .slug)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(rating, forKey: .rating)
        try container.encode(description, forKey: .description)
        try container.encode(cast, forKey: .cast)
        try container.encodeIfPresent(writers, forKey: .writers)
        try container.encodeIfPresent(duration, forKey: .duration)
        try container.encode(length, forKey: .length)
        try container.encode(genres, forKey: .genres)
        try container.encode(hasWatched, forKey: .hasWatched)
        try container.encode(isHD, forKey: .isHD)
        try container.encode(isExclusive, forKey: .isExclusive)
        try container.encode(isNewRelease, forKey: .isNewRelease)
        try container.encode(isSecret, forKey: .isSecret)
        try container.encode(resources, forKey: .resources)
        try container.encodeIfPresent(seasons, forKey: .seasons)
        try container.encodeIfPresent(numberOfEpisodes, forKey: .numberOfEpisodes)
    }
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
                     writers: writers,
                     duration: duration,
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

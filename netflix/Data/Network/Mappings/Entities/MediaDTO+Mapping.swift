//
//  MediaDTO+DataMapping.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import UIKit

// MARK: - MediaDTO struct

struct MediaDTO: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id,
             title,
             rating,
             description,
             cast,
             isHD,
             displayCover,
             detailCover,
             hasWatched,
             newRelease,
             logoPosition,
             slug,
             presentedCover,
             presentedLogo,
             presentedDisplayLogo,
             displayLogos,
             logos,
             genres,
             trailers,
             covers,
             duration,
             seasonCount,
             episodeCount,
             isNetflixExclusive,
             year,
             length,
             writers,
             previewURL
    }
    
    var id: String?
    var title: String
    var rating: CGFloat
    var description: String
    var cast: String
    var isHD: Bool
    var displayCover: String
    var detailCover: String
    var hasWatched: Bool
    var newRelease: Bool
    var logoPosition: String
    var slug: String
    var presentedCover: String?
    var presentedLogo: String?
    var presentedDisplayLogo: String?
    
    var displayLogos: [String]?
    var logos: [String]
    var genres: [String]
    var trailers: [String]
    var covers: [String]
    
    var duration: String?
    var seasonCount: Int?
    var episodeCount: Int?
    var isNetflixExclusive: Bool?
    
    var year: Int?
    var length: String?
    var writers: String?
    var previewURL: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(String.self, forKey: .id)
        let title = try container.decode(String.self, forKey: .title)
        let rating = try container.decode(CGFloat.self, forKey: .rating)
        let description = try container.decode(String.self, forKey: .description)
        let cast = try container.decode(String.self, forKey: .cast)
        let isHD = try container.decode(Bool.self, forKey: .isHD)
        let displayCover = try container.decode(String.self, forKey: .displayCover)
        let detailCover = try container.decode(String.self, forKey: .detailCover)
        let hasWatched = try container.decode(Bool.self, forKey: .hasWatched)
        let newRelease = try container.decode(Bool.self, forKey: .newRelease)
        let logoPosition = try container.decode(String.self, forKey: .logoPosition)
        let slug = try container.decode(String.self, forKey: .slug)
        let presentedCover = try container.decode(String.self, forKey: .presentedCover)
        let presentedLogo = try container.decode(String.self, forKey: .presentedLogo)
        let presentedDisplayLogo = try container.decode(String.self, forKey: .presentedDisplayLogo)
        let displayLogos = try container.decode([String].self, forKey: .displayLogos)
        let logos = try container.decode([String].self, forKey: .logos)
        let genres = try container.decode([String].self, forKey: .genres)
        let trailers = try container.decode([String].self, forKey: .trailers)
        let covers = try container.decode([String].self, forKey: .covers)
        let duration = try container.decodeIfPresent(String.self, forKey: .duration)
        let seasonCount = try container.decodeIfPresent(Int.self, forKey: .seasonCount)
        let episodeCount = try container.decodeIfPresent(Int.self, forKey: .episodeCount)
        let isNetflixExclusive = try container.decodeIfPresent(Bool.self, forKey: .isNetflixExclusive)
        let year = try container.decodeIfPresent(Int.self, forKey: .year)
        let length = try container.decodeIfPresent(String.self, forKey: .length)
        let writers = try container.decodeIfPresent(String.self, forKey: .writers)
        let previewURL = try container.decodeIfPresent(String.self, forKey: .previewURL)
        
        self.id = id
        self.title = title
        self.rating = rating
        self.description = description
        self.cast = cast
        self.isHD = isHD
        self.displayCover = displayCover
        self.detailCover = detailCover
        self.hasWatched = hasWatched
        self.newRelease = newRelease
        self.logoPosition = logoPosition
        self.slug = slug
        self.presentedCover = presentedCover
        self.presentedLogo = presentedLogo
        self.presentedDisplayLogo = presentedDisplayLogo
        self.displayLogos = displayLogos
        self.logos = logos
        self.genres = genres
        self.trailers = trailers
        self.covers = covers
        self.duration = duration
        self.seasonCount = seasonCount
        self.episodeCount = episodeCount
        self.isNetflixExclusive = isNetflixExclusive
        self.year = year
        self.length = length
        self.writers = writers
        self.previewURL = previewURL
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(rating, forKey: .rating)
        try container.encode(description, forKey: .description)
        try container.encode(cast, forKey: .cast)
        try container.encode(isHD, forKey: .isHD)
        try container.encode(displayCover, forKey: .displayCover)
        try container.encode(detailCover, forKey: .detailCover)
        try container.encode(hasWatched, forKey: .hasWatched)
        try container.encode(newRelease, forKey: .newRelease)
        try container.encode(logoPosition, forKey: .logoPosition)
        try container.encode(slug, forKey: .slug)
        try container.encode(presentedCover, forKey: .presentedCover)
        try container.encode(presentedLogo, forKey: .presentedLogo)
        try container.encode(presentedDisplayLogo, forKey: .presentedDisplayLogo)
        try container.encode(displayLogos, forKey: .displayLogos)
        try container.encode(logos, forKey: .logos)
        try container.encode(genres, forKey: .genres)
        try container.encode(trailers, forKey: .trailers)
        try container.encode(covers, forKey: .covers)
        try container.encode(duration, forKey: .duration)
        try container.encode(seasonCount, forKey: .seasonCount)
        try container.encode(episodeCount, forKey: .episodeCount)
        try container.encode(isNetflixExclusive, forKey: .isNetflixExclusive)
        try container.encode(year, forKey: .year)
        try container.encode(length, forKey: .length)
        try container.encode(writers, forKey: .writers)
        try container.encode(previewURL, forKey: .previewURL)
    }
}

// MARK: - DataMapping

extension MediaDTO {
    func toDomain() -> Media {
        return .init(id: id,
                     title: title,
                     rating: Float(rating),
                     description: description,
                     cast: cast,
                     isHD: isHD,
                     displayCover: displayCover,
                     detailCover: detailCover,
                     hasWatched: hasWatched,
                     newRelease: newRelease,
                     logoPosition: logoPosition,
                     slug: slug,
                     presentedCover: presentedCover,
                     presentedLogo: presentedLogo,
                     presentedDisplayLogo: presentedDisplayLogo,
                     isNetflixExclusive: isNetflixExclusive,
                     displayLogos: displayLogos,
                     logos: logos,
                     genres: genres,
                     trailers: trailers,
                     covers: covers,
                     duration: duration,
                     seasonCount: seasonCount,
                     episodeCount: episodeCount,
                     year: year,
                     length: length,
                     writers: writers,
                     previewURL: previewURL)
    }
}

//
//  MediaDTO+Mapping.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import UIKit

// MARK: - MediaResourcesDTO class

@objc
public final class MediaResourcesDTO: NSObject, Codable, NSSecureCoding {
    
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
    
    init(posters: [String],
         logos: [String],
         trailers: [String],
         displayPoster: String,
         displayLogos: [String],
         previewPoster: String,
         previewUrl: String,
         presentedPoster: String,
         presentedLogo: String,
         presentedDisplayLogo: String,
         presentedLogoAlignment: String) {
        self.posters = posters
        self.logos = logos
        self.trailers = trailers
        self.displayPoster = displayPoster
        self.displayLogos = displayLogos
        self.previewPoster = previewPoster
        self.previewUrl = previewUrl
        self.presentedPoster = presentedPoster
        self.presentedLogo = presentedLogo
        self.presentedDisplayLogo = presentedDisplayLogo
        self.presentedLogoAlignment = presentedLogoAlignment
    }
    
    // MARK: NSSecureCoding
    
    public static var supportsSecureCoding: Bool { true }
    
    public init?(coder: NSCoder) {
        self.posters = coder.decodeObject(of: [NSArray.self, NSString.self], forKey: "posters") as? [String] ?? []
        self.logos = coder.decodeObject(of: [NSArray.self, NSString.self], forKey: "logos") as? [String] ?? []
        self.trailers = coder.decodeObject(of: [NSArray.self, NSString.self], forKey: "trailers") as? [String] ?? []
        self.displayPoster = coder.decodeObject(of: NSString.self, forKey: "displayPoster") as? String ?? ""
        self.displayLogos = coder.decodeObject(of: [NSArray.self, NSString.self].self, forKey: "displayLogos") as? [String] ?? []
        self.previewPoster = coder.decodeObject(of: NSString.self, forKey: "previewPoster") as? String ?? ""
        self.previewUrl = coder.decodeObject(of: NSString.self, forKey: "previewUrl") as? String ?? ""
        self.presentedPoster = coder.decodeObject(of: NSString.self, forKey: "presentedPoster") as? String ?? ""
        self.presentedLogo = coder.decodeObject(of: NSString.self, forKey: "presentedLogo") as? String ?? ""
        self.presentedDisplayLogo = coder.decodeObject(of: NSString.self, forKey: "presentedDisplayLogo") as? String ?? ""
        self.presentedLogoAlignment = coder.decodeObject(of: NSString.self, forKey: "presentedLogoAlignment") as? String ?? ""
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(posters, forKey: "posters")
        coder.encode(logos, forKey: "logos")
        coder.encode(trailers, forKey: "trailers")
        coder.encode(displayPoster, forKey: "displayPoster")
        coder.encode(displayLogos, forKey: "displayLogos")
        coder.encode(previewPoster, forKey: "previewPoster")
        coder.encode(previewUrl, forKey: "previewUrl")
        coder.encode(presentedPoster, forKey: "presentedPoster")
        coder.encode(presentedLogo, forKey: "presentedLogo")
        coder.encode(presentedDisplayLogo, forKey: "presentedDisplayLogo")
        coder.encode(presentedLogoAlignment, forKey: "presentedLogoAlignment")
    }
}

//

enum MediaType: String, Codable {
  case series
  case film
}

// MARK: - MediaDTO struct

struct MediaDTO: Codable {
    
    let id: String?
  let type: MediaType
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
    
    let resources: MediaResourcesDTO
    
    let seasons: [String]?
    let numberOfEpisodes: Int?
}

// MARK: - MediaResourcesDTO + Mapping

extension MediaResourcesDTO {
    func toDomain() -> MediaResources {
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

// MARK: - MediaDTO + Mapping

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

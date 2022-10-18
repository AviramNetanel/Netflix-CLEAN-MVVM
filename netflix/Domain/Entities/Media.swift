//
//  Media.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import UIKit

// MARK: - Media struct

struct Media {
    
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
    
    struct Resources {
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
    
    let resources: Resources
    
    let seasons: [String]?
    let numberOfEpisodes: Int?
}

// MARK: - Media: Equatable implementation

extension Media: Equatable {
    static func ==(lhs: Media, rhs: Media) -> Bool { lhs.id == rhs.id }
}

// MARK: - Media: Hashable implementation

extension Media: Hashable {
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

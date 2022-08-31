//
//  Media.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import UIKit

// MARK: - Media class

struct Media {
    
    // MARK: Shared Properties
    
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
    
    // MARK: TV Show's Properties
    
    var duration: String?
    var seasonCount: Int?
    var episodeCount: Int?
    var isNetflixExclusive: Bool?
    
    // MARK: Movie's Properties
    
    var year: Int?
    var length: String?
    var writers: String?
    var previewURL: String?
}

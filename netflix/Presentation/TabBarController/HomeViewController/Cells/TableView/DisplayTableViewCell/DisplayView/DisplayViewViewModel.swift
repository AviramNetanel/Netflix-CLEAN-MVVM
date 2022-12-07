//
//  DisplayViewViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 16/09/2022.
//

import Foundation

struct DisplayViewViewModel {
    enum PresentedLogo: String {
        case first = "0"
        case second = "1"
        case third = "2"
        case fourth = "3"
        case fifth = "4"
        case sixth = "5"
        case seventh = "6"
    }
    
    let slug: String
    let genres: [String]
    let posterImagePath: String
    var posterImageIdentifier: NSString
    var posterImageURL: URL!
    var logoImagePath: String
    var logoImageIdentifier: NSString
    var logoImageURL: URL!
    var attributedGenres: NSMutableAttributedString!
    
    init(with media: Media) {
        self.slug = media.slug
        self.posterImagePath = media.resources.displayPoster
        self.logoImagePath = .init()
        self.genres = media.genres
        self.attributedGenres = .init()
        self.posterImageIdentifier = .init(string: "displayPoster_\(self.slug)")
        self.logoImageIdentifier = .init(string: "displayLogo_\(self.slug)")
        self.logoImagePath = path(with: media)!
        self.posterImageURL = .init(string: self.posterImagePath)
        self.logoImageURL = .init(string: self.logoImagePath)
        self.attributedGenres = self.genres(for: media)
    }
    
    fileprivate func path(with media: Media) -> String? {
        switch PresentedLogo(rawValue: media.resources.presentedDisplayLogo) {
        case .first: return media.resources.logos[0]
        case .second: return media.resources.logos[1]
        case .third: return media.resources.logos[2]
        case .fourth: return media.resources.logos[3]
        case .fifth: return media.resources.logos[4]
        case .sixth: return media.resources.logos[5]
        case .seventh: return media.resources.logos[6]
        default: return nil
        }
    }
    
    fileprivate func genres(for media: Media) -> NSMutableAttributedString {
        guard
            let symbol = " · " as String?,
            let genres = media.genres as [String]?
        else { return .init() }
        
        let mutableString = NSMutableAttributedString()
        let genresAttributes = NSAttributedString.displayGenresAttributes
        let separatorAttributes = NSAttributedString.displayGenresSeparatorAttributes
        let mappedGenres = genres.enumerated().map { NSAttributedString(string: $0.element,
                                                                        attributes: genresAttributes) }
        
        for genre in mappedGenres {
            mutableString.append(genre)
            let attributedSeparator = NSAttributedString(string: symbol, attributes: separatorAttributes)
            if genre == mappedGenres.last { continue }
            mutableString.append(attributedSeparator)
        }
        
        return mutableString
    }
}

//
//  DisplayViewViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 16/09/2022.
//

import Foundation

// MARK: - ViewModelInput protocol

private protocol ViewModelInput {
    func path(with media: Media) -> String?
    func genres(for media: Media) -> NSMutableAttributedString
}

// MARK: - ViewModelOutput protocol

private protocol ViewModelOutput {
    var slug: String { get }
    var posterImagePath: String { get }
    var logoImagePath: String { get }
    var genres: [String] { get }
}

// MARK: - ViewModel typealias

private typealias ViewModel = ViewModelInput & ViewModelOutput

// MARK: - DisplayViewViewModel struct

struct DisplayViewViewModel: ViewModel {
    
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
        self.posterImagePath = media.displayCover
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
        switch PresentedLogo(rawValue: media.presentedDisplayLogo!) {
        case .first: return media.logos[0]
        case .second: return media.logos[1]
        case .third: return media.logos[2]
        case .fourth: return media.logos[3]
        case .fifth: return media.logos[4]
        case .sixth: return media.logos[5]
        case .seventh: return media.logos[6]
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


//
//  DefaultCollectionViewCellItemViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 08/09/2022.
//

import Foundation

// MARK: - CollectionViewCellItemViewModelInput protocol

private protocol CollectionViewCellItemViewModelInput {
    var indexPath: IndexPath { get }
    var title: String { get }
    var slug: String { get }
    var covers: [String] { get }
    var logos: [String] { get }
    var logoAlignment: DefaultCollectionViewCellItemViewModel.LogoAlignment { get }
    var posterImagePath: String { get }
    var posterImageIdentifier: NSString { get }
    var posterImageURL: URL! { get }
    var logoImagePath: String { get }
    var logoImageIdentifier: NSString { get }
    var logoImageURL: URL! { get }
}

// MARK: - CollectionViewCellItemViewModelOutput protocol

private protocol CollectionViewCellItemViewModelOutput {
    func path<T>(for type: T.Type, with media: Media) -> String?
}

// MARK: - CollectionViewCellItemViewModel protocol

private protocol CollectionViewCellItemViewModel: CollectionViewCellItemViewModelInput,
                                                  CollectionViewCellItemViewModelOutput {}

// MARK: - DefaultCollectionViewCellItemViewModel struct

struct DefaultCollectionViewCellItemViewModel: CollectionViewCellItemViewModel {
    
    enum LogoAlignment: String {
        case top
        case midTop = "mid-top"
        case mid
        case midBottom = "mid-bottom"
        case bottom
    }
    
    enum PresentedPoster: String {
        case first = "0"
        case second = "1"
        case third = "2"
        case fourth = "3"
        case fifth = "4"
        case sixth = "5"
    }
    
    enum PresentedLogo: String {
        case first = "0"
        case second = "1"
        case third = "2"
        case fourth = "3"
        case fifth = "4"
        case sixth = "5"
        case seventh = "6"
    }
    
    let indexPath: IndexPath
    let title: String
    let slug: String
    let covers: [String]
    let logos: [String]
    let logoAlignment: LogoAlignment
    var posterImagePath: String
    var posterImageIdentifier: NSString
    var posterImageURL: URL!
    var logoImagePath: String
    var logoImageIdentifier: NSString
    var logoImageURL: URL!
    
    init(media: Media, indexPath: IndexPath) {
        self.indexPath = indexPath
        self.title = media.title
        self.slug = media.slug
        self.covers = media.covers
        self.logos = media.logos
        self.posterImagePath = .init()
        self.logoImagePath = .init()
        self.logoAlignment = .init(rawValue: media.logoPosition)!
        self.posterImageIdentifier = .init(string: "poster_\(media.slug)")
        self.logoImageIdentifier = .init(string: "logo_\(media.slug)")
        self.posterImagePath = path(for: PresentedPoster.self, with: media)!
        self.logoImagePath = path(for: PresentedLogo.self, with: media)!
        self.posterImageURL = URL(string: self.posterImagePath)
        self.logoImageURL = URL(string: self.logoImagePath)
    }
    
    fileprivate func path<T>(for type: T.Type, with media: Media) -> String? {
        switch type {
        case is PresentedPoster.Type:
            switch PresentedPoster(rawValue: media.presentedCover!) {
            case .first: return covers[0]
            case .second: return covers[1]
            case .third: return covers[2]
            case .fourth: return covers[3]
            case .fifth: return covers[4]
            case .sixth: return covers[5]
            default: return nil
            }
        default:
            switch PresentedLogo(rawValue: media.presentedLogo!) {
            case .first: return logos[0]
            case .second: return logos[1]
            case .third: return logos[2]
            case .fourth: return logos[3]
            case .fifth: return logos[4]
            case .sixth: return logos[5]
            case .seventh: return logos[6]
            default: return nil
            }
        }
    }
}

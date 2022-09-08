//
//  SectionIndices.swift
//  netflix
//
//  Created by Zach Bazov on 08/09/2022.
//

import Foundation

// MARK: - SectionIndices enum

enum SectionIndices: Int, CaseIterable {
    case display
    case ratable
    case resumable
    case action
    case sciFi
    case blockbuster
    case myList
    case crime
    case thriller
    case adventure
    case comedy
    case drama
    case horror
    case anime
    case familyNchildren
    case documentary
}

// MARK: - Valuable implementation

extension SectionIndices: Valuable {
    var stringValue: String {
        switch self {
        case .display,
                .ratable,
                .resumable,
                .myList:
            return ""
        case .action: return "Action"
        case .sciFi: return "Sci-Fi"
        case .blockbuster: return "Blockbusters"
        case .crime: return "Crime"
        case .thriller: return "Thriller"
        case .adventure: return "Adventure"
        case .comedy: return "Comedy"
        case .drama: return "Drama"
        case .horror: return "Horror"
        case .anime: return "Anime"
        case .familyNchildren: return "Family & Children"
        case .documentary: return "Documentary"
        }
    }
}

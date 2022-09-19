//
//  DefaulltNavigationItemViewViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 17/09/2022.
//

import Foundation

// MARK: - NavigationItemViewViewModelInput protocol

private protocol NavigationItemViewViewModelInput {
    var tag: Int { get }
    var title: String! { get }
    var image: String! { get }
}

// MARK: - NavigationItemViewViewModelOutput protocol

private protocol NavigationItemViewViewModelOutput {
    func title(for tag: Int) -> String?
    func image(for tag: Int) -> String?
}

// MARK: - NavigationItemViewViewModel protocol

private protocol NavigationItemViewViewModel: NavigationItemViewViewModelInput,
                                              NavigationItemViewViewModelOutput {}

// MARK: - DefaultNavigationItemViewViewModel struct

struct DefaultNavigationViewItemViewViewModel: NavigationItemViewViewModel {
    
    let tag: Int
    var title: String!
    var image: String!
    
    init(tag: Int) {
        self.tag = tag
        self.title = title(for: tag)
        self.image = image(for: tag)
    }
    
    fileprivate func title(for tag: Int) -> String? {
        guard let state = DefaultNavigationView.State(rawValue: tag) else { return nil }
        switch state {
        case .tvShows: return "TV Shows"
        case .movies: return "Movies"
        case .categories: return "Categories"
        default: return nil
        }
    }
    
    fileprivate func image(for tag: Int) -> String? {
        guard let state = DefaultNavigationView.State(rawValue: tag) else { return nil }
        switch state {
        case .home: return "netflix-logo-sm"
        case .airPlay: return "airplayvideo"
        case .account: return "person.circle"
        default: return nil
        }
    }
}

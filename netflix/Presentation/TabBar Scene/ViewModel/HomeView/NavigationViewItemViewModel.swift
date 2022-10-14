//
//  NavigationViewItemViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 17/09/2022.
//

import Foundation

// MARK: - ViewModelInput protocol

private protocol ViewModelInput {
    func title(for tag: Int) -> String?
    func image(for tag: Int) -> String?
}

// MARK: - ViewModelOutput protocol

private protocol ViewModelOutput {
    var tag: Int { get }
    var title: String! { get }
    var image: String! { get }
}

// MARK: - ViewModel typealias

private typealias ViewModel = ViewModelInput & ViewModelOutput

// MARK: - NavigationViewItemViewModel struct

struct NavigationViewItemViewModel: ViewModel {
    
    let tag: Int
    var title: String!
    var image: String!
    var hasInteracted: Bool
    
    init(tag: Int) {
        self.hasInteracted = false
        self.tag = tag
        self.title = title(for: tag)
        self.image = image(for: tag)
    }
    
    fileprivate func title(for tag: Int) -> String? {
        guard let state = NavigationView.State(rawValue: tag) else { return nil }
        switch state {
        case .tvShows: return "TV Shows"
        case .movies: return "Movies"
        case .categories: return "Categories"
        default: return nil
        }
    }
    
    fileprivate func image(for tag: Int) -> String? {
        guard let state = NavigationView.State(rawValue: tag) else { return nil }
        switch state {
        case .home: return "netflix-logo-sm"
        case .airPlay: return "airplayvideo"
        case .account: return "person.circle"
        default: return nil
        }
    }
}

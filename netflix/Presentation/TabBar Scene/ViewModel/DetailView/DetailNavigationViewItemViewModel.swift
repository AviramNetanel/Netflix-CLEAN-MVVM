//
//  DetailNavigationViewItemViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 04/10/2022.
//

import Foundation

// MARK: - ViewModelInput protocol

private protocol ViewModelInput {
    
}

// MARK: - ViewModelOutput protocol

private protocol ViewModelOutput {
    var tag: Int { get }
}

// MARK: - ViewModel typealias

private typealias ViewModel = ViewModelInput & ViewModelOutput

// MARK: - DetailNavigationViewItemViewModel struct

struct DetailNavigationViewItemViewModel: ViewModel {
    
    let tag: Int
    
    var title: String {
        guard let tag = DetailNavigationViewItem.Item(rawValue: tag) else { fatalError() }
        switch tag {
        case .episodes: return "Episodes"
        case .trailers: return "Trailers"
        case .similarContent: return "Similar Content"
        }
    }
}

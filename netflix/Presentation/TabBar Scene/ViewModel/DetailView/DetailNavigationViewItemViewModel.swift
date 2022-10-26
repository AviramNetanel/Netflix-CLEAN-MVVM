//
//  DetailNavigationViewItemViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 04/10/2022.
//

import Foundation

// MARK: - ViewModelInput protocol

private protocol ViewModelInput {}

// MARK: - ViewModelOutput protocol

private protocol ViewModelOutput {
    var tag: Int { get }
    var isSelected: Bool { get }
    var title: String { get }
}

// MARK: - ViewModel typealias

private typealias ViewModel = ViewModelInput & ViewModelOutput

// MARK: - DetailNavigationViewItemViewModel class

final class DetailNavigationViewItemViewModel: ViewModel {
    
    fileprivate let tag: Int
    fileprivate var isSelected: Bool
    
    var title: String {
        guard let tag = DetailNavigationView.State(rawValue: tag) else { fatalError() }
        switch tag {
        case .episodes: return "Episodes"
        case .trailers: return "Trailers"
        case .similarContent: return "Similar Content"
        }
    }
    
    init(with item: DetailNavigationViewItem) {
        self.tag = item.tag
        self.isSelected = item.isSelected
    }
}

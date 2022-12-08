//
//  DetailNavigationViewItemViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 04/10/2022.
//

import Foundation

final class DetailNavigationViewItemViewModel {
    private let tag: Int
    private var isSelected: Bool
    
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

//
//  DetailPanelViewItemViewModel.swift
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
    var systemImage: String { get }
    var title: String { get }
}

// MARK: - ViewModel typealias

private typealias ViewModel = ViewModelInput & ViewModelOutput

// MARK: - DetailPanelViewItemViewModel struct

struct DetailPanelViewItemViewModel: ViewModel {
    
    let tag: Int
    
    private(set) var isSelected = false
    
    var systemImage: String {
        guard let tag = DetailPanelViewItemConfiguration.Item(rawValue: tag) else { fatalError() }
        switch tag {
        case .myList: return isSelected ? "checkmark" : "plus"
        case .rate: return isSelected ? "hand.thumbsup.fill" : "hand.thumbsup"
        case .share: return "square.and.arrow.up"
        }
    }
    
    var title: String {
        guard let tag = DetailPanelViewItemConfiguration.Item(rawValue: tag) else { fatalError() }
        switch tag {
        case .myList: return "My List"
        case .rate: return "Rate"
        case .share: return "Share"
        }
    }
}

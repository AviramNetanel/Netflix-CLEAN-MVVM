//
//  DetailPanelViewItemViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 04/10/2022.
//

import Foundation

// MARK: - ViewModelInput protocol

private protocol ViewModelInput {
    func bind(on item: DetailPanelViewItem)
    func removeObservers()
}

// MARK: - ViewModelOutput protocol

private protocol ViewModelOutput {
    var tag: Int { get }
    var isSelected: Observable<Bool> { get }
    var systemImage: String { get }
    var title: String { get }
}

// MARK: - ViewModel typealias

private typealias ViewModel = ViewModelInput & ViewModelOutput

// MARK: - DetailPanelViewItemViewModel class

final class DetailPanelViewItemViewModel: ViewModel {
    
    let tag: Int
    var isSelected: Observable<Bool>
    
    var systemImage: String {
        guard let tag = DetailPanelViewItemConfiguration.Item(rawValue: tag) else { fatalError() }
        switch tag {
        case .myList: return isSelected.value ? "checkmark" : "plus"
        case .rate: return isSelected.value ? "hand.thumbsup.fill" : "hand.thumbsup"
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
    
    init(with item: DetailPanelViewItem) {
        self.tag = item.tag
        self.isSelected = .init(item.isSelected)
        self.bind(on: item)
    }
    
    fileprivate func bind(on item: DetailPanelViewItem) {
        isSelected.observe(on: self) { _ in item.configuration?.viewDidConfigure() }
    }
    
    func removeObservers() {
        isSelected.remove(observer: self)
    }
}
